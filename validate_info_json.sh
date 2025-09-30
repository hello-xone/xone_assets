#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./validate_info_json.sh [--strict] [paths...]
DEFAULT_ROOTS=("blockchains/xone" "blockchains/xone_testnet")

STRICT=false
ROOTS=()

for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=true ;;
    *) ROOTS+=("$arg") ;;
  esac
done
[[ ${#ROOTS[@]} -eq 0 ]] && ROOTS=("${DEFAULT_ROOTS[@]}")

command -v jq >/dev/null 2>&1 || { echo "Error: jq is required." >&2; exit 127; }

read -r -d '' JQ_PROG <<'JQ' || true
def err($m): [$m];
def type_is($v; $t): (( $v|type ) == $t);

# Section guards
def obj_or_missing($v; $prefix):
  if $v == null then err($prefix+": missing section")
  elif ($v|type) != "object" then err($prefix+": not object")
  else [] end;

# Unknown-field reporter
def unknown_fields($obj; $allowed; $prefix):
  ( ( $obj|keys ) - $allowed ) | map($prefix + "." + . + ": unknown field");

# String field checkers
# - required non-empty (always enforced) for Basic Information
def check_required_strings_nonempty($obj; $keys; $prefix):
  reduce $keys[] as $k ([]; . +
    (if $obj|has($k) then
       ( if type_is($obj[$k]; "string")
           then (if ($obj[$k] == "") then err($prefix+"."+$k+": empty") else [] end)
           else err($prefix+"."+$k+": not string")
         end)
     else err($prefix+"."+$k+": missing")
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
     else err($prefix+"."+$k+": missing")
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
    err($prefix+"."+$key+": missing")
  end;

def validate:
  . as $root
  | ( []
      +
      # ----- Basic Information (all required & non-empty) -----
      ( ( $root["Basic Information"] ) as $bi
        | obj_or_missing($bi; "Basic Information")
        +
          ( if $bi != null and ($bi|type) == "object" then
              ( check_required_strings_nonempty($bi;
                  ["name","website","description","whitepaper","explorer","type","symbol","status","email","id"];
                  "Basic Information")
                +
                check_integer($bi; "decimals"; "Basic Information")
                +
                unknown_fields($bi;
                  ["name","website","description","whitepaper","explorer","type","symbol","decimals","status","email","id"];
                  "Basic Information")
              )
            else [] end )
      )
      +
      # ----- Social Profiles -----
      ( ( $root["Social Profiles"] ) as $sp
        | obj_or_missing($sp; "Social Profiles")
        +
          ( if $sp != null and ($sp|type) == "object" then
              ( check_strings($sp;
                  ["twitter","telegram","reddit","discord","slack","instagram","wechat","facebook","medium","github","blog","bitcointalk","youtube","tiktok","forum","linkedin","opensea"];
                  "Social Profiles")
                +
                unknown_fields($sp;
                  ["twitter","telegram","reddit","discord","slack","instagram","wechat","facebook","medium","github","blog","bitcointalk","youtube","tiktok","forum","linkedin","opensea"];
                  "Social Profiles")
              )
            else [] end )
      )
      +
      # ----- Price Data -----
      ( ( $root["Price Data"] ) as $pd
        | obj_or_missing($pd; "Price Data")
        +
          ( if $pd != null and ($pd|type) == "object" then
              ( check_strings($pd; ["coinMarketCap","coinGecko","ave"]; "Price Data")
                +
                unknown_fields($pd; ["coinMarketCap","coinGecko","ave"]; "Price Data")
              )
            else [] end )
      )
      +
      # ----- Unknown top-level sections -----
      unknown_fields($root; ["Basic Information","Social Profiles","Price Data"]; "root")
    );

validate
| (if length==0 then ["OK"] else . end)[]
JQ

shopt -s nullglob
mapfile -t FILES < <(find "${ROOTS[@]}" -type f -name 'info.json' -print)

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
