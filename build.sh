
PUB=../../../intellij/dart-sdk/bin/pub

git branch -D gh-pages
git checkout -b gh-pages
$PUB build
git add -A build
git commit -m "Build pages `date`"
git checkout master
echo "Built examples on gh-pages branch"

