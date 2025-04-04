#!/bin/sh

starts_with() {
  LHS="$1"
  RHS="$2"

  if [ ${LHS:0:${#RHS}} = $RHS ]; then
    return 0
  else
    return 1
  fi
}

get_expanded_imports() {
  CALLER_FILE_NAME="$1"

  IFS=$'\n'
  RELATIVE_IMPORT_LINES=''
  for IMPORT_LINE in $(grep -E "from '.+';$" "$CALLER_FILE_NAME"); do
    INPUT_FILE_DIR_PATH=${CALLER_FILE_NAME%/*}
    IMPORT_PATH=$(printf "$IMPORT_LINE" | sed -E "s/^.*'(.*)';$/\1/")

    if starts_with "$IMPORT_PATH" 'src/'; then
      UNEXPENDED_IMPORT_LINE="$IMPORT_PATH"
    elif starts_with "$IMPORT_PATH" '.'; then
      UNEXPENDED_IMPORT_LINE="$INPUT_FILE_DIR_PATH/$IMPORT_PATH"
    else
      RELATIVE_IMPORT_LINES="$RELATIVE_IMPORT_LINES\n$IMPORT_PATH"
      continue
    fi

    EXPANDED_IMPORT_LINE=$(realpath "$UNEXPENDED_IMPORT_LINE")
    RELATIVE_IMPORT_LINE=${EXPANDED_IMPORT_LINE##$PWD/}
    RELATIVE_IMPORT_LINES="$RELATIVE_IMPORT_LINES\n$RELATIVE_IMPORT_LINE"
  done

  printf "$RELATIVE_IMPORT_LINES\n"
}

print_usages() {
  FOUND="$1"
  LEGACY_CANDIDATE_FILE_PATH="$2"

  IFS=$'\n'
  for FOUND_LINE in ${FOUND[@]}; do
    CALLER_FILE_NAME="${FOUND_LINE%%:*}"
    CANONICAL_LEGACY_FILE_PATH=${LEGACY_CANDIDATE_FILE_PATH%%\.js}
    CANONICAL_LEGACY_FILE_PATH=${CANONICAL_LEGACY_FILE_PATH%/index}

    if ! get_expanded_imports "$CALLER_FILE_NAME" | grep -n "$CANONICAL_LEGACY_FILE_PATH" > /dev/null 2>&1; then
      continue
    fi

    printf "O: $CALLER_FILE_NAME -> $LEGACY_CANDIDATE_FILE_PATH\n"

    CALLER_LINE="${FOUND_LINE#*:}"

    printf "\t$CALLER_LINE\n"
  done
}

PRINT_USAGE=0
while [ $# -gt 0 ] && [ ${1:0:1} = '-' ]; do
  case $1 in
    --print-usage)
      PRINT_USAGE=1
      ;;
  esac

  shift
done

if [ $# -lt 2 ]; then
  printf "Usage: $(basename $0) [--print-usage] CALLEES_FILE_NAME CALLERS_FILE_NAME\n" > /dev/stderr
  exit 1
fi

CALLEES_FILE_NAME="$1"
CALLERS_FILE_NAME="$2"

LEGACY_CANDIDATES=$(
  cat "$CALLEES_FILE_NAME" \
  | xargs -i{} grep -H -E '^(async )?function' {} \
  | sed -E 's/(async )?function //' \
  | sed 's/(.*//'
)

for LEGACY_CANDIDATE in ${LEGACY_CANDIDATES[@]}; do
  LEGACY_CANDIDATE_FUNCTION_NAME=${LEGACY_CANDIDATE##*:}
  LEGACY_CANDIDATE_FILE_PATH=${LEGACY_CANDIDATE%:*}

  if ! FOUND=$(cat "$CALLERS_FILE_NAME" | xargs grep -H -n "\.$LEGACY_CANDIDATE_FUNCTION_NAME("); then
    printf "X: $LEGACY_CANDIDATE_FILE_PATH.$LEGACY_CANDIDATE_FUNCTION_NAME\n"
    continue
  fi

  if [ $PRINT_USAGE -ne 1 ]; then
    continue
  fi

  if [ -n "$FOUND" ]; then
    print_usages "$FOUND" "$LEGACY_CANDIDATE_FILE_PATH"
  fi
done
