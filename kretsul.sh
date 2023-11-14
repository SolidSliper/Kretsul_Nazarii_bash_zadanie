#Kretsul Nazarii
#!/bin/bash
cat <<THE_END
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
</head>
<body>
THE_END
OVER_CI_ZOZ=0
while IFS= read LINE
do
	if echo "$LINE" | grep '^\s*$' >/dev/null
        then
		if [ $OVER_CI_ZOZ = 1 ]; then  #Robim aj tu vypis konca zoznamu v pripade ze bude prazdny riadok
			echo "</ul>"           #Preco? pretoze tato moja podmienka na prazdny riadok ma continue -
			OVER_CI_ZOZ=0          #-ak riadok je prazdny, tak nie potrebujem spravit ine dalsie podmienky
		fi
		echo "<p>"
		continue
	elif [[ $LINE == \#\ * ]]; then  # podmienka cez rozsireny syntaxis
		LINE=$(echo "$LINE" | sed 's@^# \(.*\)$@<h1>\1</h1>@')
		echo "$LINE"
	elif echo "$LINE" | grep '^## ' >/dev/null; then  # podmienka cez grep
		LINE=$(echo "$LINE" | sed 's@^## \(.*\)$@<h2>\1</h2>@')
		echo "$LINE"
	elif [[ $LINE == *"__"* ]]; then  # podmienka cez rozsireny syntaxis
		LINE=$(echo "$LINE" | sed -r 's@__([^_]+)__@<strong>\1</strong>@g')
		echo "$LINE"
	elif echo "$LINE" | grep '_.*_' >/dev/null; then  # podmienka cez grep
                LINE=$(echo "$LINE" | sed -r 's@_([^_]+)_@<em>\1</em>@g')
                echo "$LINE"
	elif echo "$LINE" | grep '<.*>' >/dev/null; then
		LINE=$(echo "$LINE" | sed -r 's@<https://([^<]+)>@<a href="https:\1">https://\1</a>@g')
		echo "$LINE"
	elif [[ $LINE == "- "* ]]; then
		if [ $OVER_CI_ZOZ = 0 ]; then
			echo "<ul>"
			OVER_CI_ZOZ=1
		fi
		LINE=$(echo "$LINE" | sed -r 's|- (.*)$|<li>\1</li>|')
		echo "$LINE"
		continue
	elif [ $OVER_CI_ZOZ = 1 ]; then
		echo "</ul>"
		echo "$LINE"
		OVER_CI_ZOZ=0
        else
    		echo "$LINE"
	fi
done
echo "</body>"
echo "</html>"

