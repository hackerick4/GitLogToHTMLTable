@echo off
SET /P from=Please enter your start point(tags/commit ID):
SET /P to=Please enter your end point(tags/commit ID): 
IF "%from%"=="" GOTO Error
IF "%to%"=="" GOTO Error

echo ^<HEAD^> >> script
echo ^<script language="javascript" type="text/javascript"^> >> script
echo function filter() { >> script
echo  var input, filter, table, tr, td, i; >> script
echo  input = document.getElementById("myKey"); >> script
echo  filter = input.value.toUpperCase(); >> script
echo  table = document.getElementById("myTable"); >> script
echo  tr = table.getElementsByTagName("tr"); >> script
echo  for (i = 0; i ^< tr.length; i++) { >> script
echo    td = tr[i].getElementsByTagName("td")[2]; >> script
echo    if (td) { >> script
echo      if (td.innerHTML.toUpperCase().indexOf(filter) ^> -1) { >> script
echo        tr[i].style.display = ""; >> script
echo      } else { >> script
echo        tr[i].style.display = "none"; >> script
echo      } >> script
echo    }       >> script
echo  } >> script
echo } >> script

echo ^</script^> >> script
echo ^</HEAD^> >> script

echo ^<body^>  >> tmp1
echo ^<input type="text" id="myKey" style="height:40px;font-size:14pt;" onkeyup="filter()" placeholder="Search for words" ^>^</br^>^</br^> >> tmp1
echo ^<table id="myTable" style="width:100%%"  border="1" ^>  >> tmp1

echo ^</table^> >> tmp3
echo ^</body^>  >> tmp3
git log %from%..%to% --encoding=big5 --no-merges --oneline --pretty=format:"</td></tr><tr><td><a href="http://URL/commits/%%h">%%h</a></td><td>%%cn</td><td Width="40%%">%%s</td><td>" --name-only | sed ':a;N;$!ba;s/\n/^<br^>/g'>> tmp2


type script tmp1 tmp2 tmp3 > %from%~%to%.htm

del script
del tmp1 
del tmp2 
del tmp3

:Error
:End