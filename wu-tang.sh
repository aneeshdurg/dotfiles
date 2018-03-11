name=$@
name=$(echo $name | tr \  +)
curl -i -X POST -H "Content-Type:  application/x-www-form-urlencoded" -d 'realname='$name'&Submit=Enter+the+Wu-Tang' http://www.mess.be/inickgenwuname.php 2>/dev/null | grep -A1 From | tr -d '\n' | rev | cut -d . -f1 | rev | cut -d \  -f2-
