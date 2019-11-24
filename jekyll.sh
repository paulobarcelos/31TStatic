JEKYLL_ENV=$1
SRC=$2
DEST=$3
jekyll build --source "$SRC" --destination "$DEST"
