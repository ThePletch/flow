cd coffee
cat $(ls | grep coffee) > out.coffee
coffee -c out.coffee
mv out.js ../flow.js
rm out.coffee
cd ..
python -m SimpleHTTPServer
