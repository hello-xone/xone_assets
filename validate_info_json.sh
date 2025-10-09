#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./validate_info_json.sh [--strict] [paths...]
#   ./validate_info_json.sh --scan-all <path> [--scan-all <path> ...]
#
# Examples:
#   # Scan all info.json under default roots
#   ./validate_info_json.sh
#
#   # Scan specific info.json files (for PR workflow)
#   ./validate_info_json.sh blockchains/xone/assets/0x123.../info.json
#
#   # Scan all info.json under custom directories
#   ./validate_info_json.sh blockchains/xone/assets
#
DEFAULT_ROOTS=("blockchains/xone/assets" "blockchains/xone_testnet/assets")

STRICT=false
ROOTS=()
SCAN_PATHS=()

while (($#)); do
  case "$1" in
    --strict)
      STRICT=true
      ;;
    --scan-all)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: --scan-all requires a path argument" >&2
        exit 1
      fi
      SCAN_PATHS+=("$1")
      ;;
    --scan-all=*)
      SCAN_PATHS+=("${1#*=}")
      ;;
    *)
      ROOTS+=("$1")
      ;;
  esac
  shift || true
done

if [[ ${#ROOTS[@]} -eq 0 && ${#SCAN_PATHS[@]} -eq 0 ]]; then
  ROOTS=("${DEFAULT_ROOTS[@]}")
fi

command -v jq >/dev/null 2>&1 || { echo "Error: jq is required." >&2; exit 127; }

read -r -d '' JQ_PROG <<'JQ' || true
def err($m): [$m];
def type_is($v; $t): (( $v|type ) == $t);

# Section guards
def obj_or_missing($v; $prefix):
  if $v == null then err("ERROR: "+$prefix+": missing section")
  elif ($v|type) != "object" then err($prefix+": not object")
  else [] end;

# String field checkers
# - required non-empty (always enforced) for Basic_Information
def check_required_strings_nonempty($obj; $keys; $prefix):
  reduce $keys[] as $k ([]; . +
    (if $obj|has($k) then
       ( if type_is($obj[$k]; "string")
           then (if ($obj[$k] == "") then err($prefix+"."+$k+": empty") else [] end)
           else err($prefix+"."+$k+": not string")
         end)
     else err("ERROR: "+$prefix+"."+$k+": missing")
     end)
  );

# - optional empty unless --strict for other sections
def check_strings($obj; $keys; $prefix):
  reduce $keys[] as $k ([]; . +
    (if $obj|has($k) then
       ( if type_is($obj[$k]; "string")
           then (if $strict and ($obj[$k] == "") then err($prefix+"."+$k+": empty") else [] end)
           else err($prefix+"."+$k+": not string")
         end)
     else err("ERROR: "+$prefix+"."+$k+": missing")
     end)
  );

# - optional string fields (can be missing or empty)
def check_optional_strings($obj; $keys; $prefix):
  reduce $keys[] as $k ([]; . +
    (if $obj|has($k) then
       ( if type_is($obj[$k]; "string")
           then []
           else err($prefix+"."+$k+": not string")
         end)
     else []
     end)
  );

# - optional array fields
def check_optional_arrays($obj; $keys; $prefix):
  reduce $keys[] as $k ([]; . +
    (if $obj|has($k) then
       ( if type_is($obj[$k]; "array")
           then []
           else err($prefix+"."+$k+": not array")
         end)
     else []
     end)
  );

# Integer field
def check_integer($obj; $key; $prefix):
  if $obj|has($key) then
    ( if type_is($obj[$key]; "number") and (($obj[$key]|floor) == ($obj[$key]))
        then []
        else err($prefix+"."+$key+": not integer number")
      end )
  else
    err("ERROR: "+$prefix+"."+$key+": missing")
  end;

def validate:
  . as $root
  | ( []
      +
      # ----- Basic_Information (all required & non-empty) -----
      ( ( $root["Basic_Information"] ) as $bi
        | obj_or_missing($bi; "Basic_Information")
        +
          ( if $bi != null and ($bi|type) == "object" then
              ( check_required_strings_nonempty($bi;
                  ["name","website","description","whitepaper","explorer","type","symbol","status","email","id"];
                  "Basic_Information")
                +
                check_integer($bi; "decimals"; "Basic_Information")
                +
                check_optional_strings($bi; ["research"]; "Basic_Information")
                +
                check_optional_arrays($bi; ["tags"]; "Basic_Information")
              )
            else [] end )
      )
      +
      # ----- Social_Profiles -----
      ( ( $root["Social_Profiles"] ) as $sp
        | obj_or_missing($sp; "Social_Profiles")
        +
          ( if $sp != null and ($sp|type) == "object" then
              ( check_optional_strings($sp;
                  ["twitter","telegram","reddit","discord","slack","instagram","wechat","facebook","medium","github","blog","bitcointalk","youtube","tiktok","forum","linkedin","opensea"];
                  "Social_Profiles")
              )
            else [] end )
      )
      +
      # ----- Price_Data -----
      ( ( $root["Price_Data"] ) as $pd
        | obj_or_missing($pd; "Price_Data")
        +
          ( if $pd != null and ($pd|type) == "object" then
              ( check_optional_strings($pd; ["coinMarketCap","coinGecko","ave"]; "Price_Data") )
            else [] end )
      )
    );

validate
| (if length==0 then ["OK"] else . end)[]
JQ

shopt -s nullglob

# If ROOTS contains file paths (not directories), scan those files directly
# Otherwise, find all info.json files under the root directories
FILES=()

collect_from_path() {
  local path="$1"
  if [[ -f "$path" ]]; then
    if [[ "$(basename "$path")" == "info.json" ]]; then
      FILES+=("$path")
    fi
  elif [[ -d "$path" ]]; then
    mapfile -t found_files < <(find "$path" -type f -name 'info.json' -print | sort)
    FILES+=("${found_files[@]}")
  fi
}

for scan in "${SCAN_PATHS[@]}"; do
  collect_from_path "$scan"
done

for root in "${ROOTS[@]}"; do
  collect_from_path "$root"
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No info.json files found under: ${ROOTS[*]}"
  exit 0
fi

had_error=false

for file in "${FILES[@]}"; do
  mapfile -t out < <(jq -r --argjson strict "$STRICT" "$JQ_PROG" "$file" 2>&1 || true)

  if [[ "${out[*]}" == *"jq: error"* || "${out[*]}" == *"parse error"* ]]; then
    echo "=== $file ==="
    echo "  - Invalid JSON (jq parse error)"
    had_error=true
    continue
  fi

  if [[ ${#out[@]} -eq 1 && "${out[0]}" == "OK" ]]; then
    echo "[OK] $file"
  else
    echo "=== $file ==="
    for line in "${out[@]}"; do
      [[ "$line" == "OK" || -z "$line" ]] && continue
      echo "  - $line"
      had_error=true
    done
  fi
done

if $had_error; then exit 1; else exit 0; fi