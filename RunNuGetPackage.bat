@echo off
echo ================[如果出现找不到路径，请检查批处理的环境变量]================
::设置延缓环境变量
setlocal enabledelayedexpansion
cd..
echo ================[环境变量初始化开始]
echo ================[开始查找项目名称]
set projectName="null"
for %%a in (%cd%\*.csproj) do (
	set projectName=%%~na
)
if "%errorlevel%" NEQ "0" (
	echo ================[查找项目名称出错]
	rem goto end
) else (
	echo ================[查找项目名称成功]
)
if "%projectName%"=="null" (
	echo ================[获取项目名称出错]
	rem goto end
) else (
	echo ================[获取项目名称成功]
	echo ================[项目名称：%projectName%]
)
set nugetRunFilePath=%cd%"\NuGetRun\nuget.exe"
set nuGetPath="bin\NuGet\"
set releaseFileName=%projectName%".Release.nupkg"
set releaseSymbolsFileName=%projectName%".Release.Symbols.nupkg"
set debugSymbolsFileName=%projectName%".Debug.Symbols.nupkg"
set debugFileName=%projectName%".Debug.nupkg"
set nugetApiKey="Admin:Admin"
set nugetReleaseSource="http://localhost:8001/nuget/ReleaseDefault"
set nugetReleaseSymbolsSource="http://localhost:8001/nuget/SymbolsReleaseDefault"
set nugetDebugSymbolsSource="http://localhost:8001/nuget/SymbolsDebugDefault"
set nugetDebugSource="http://localhost:8001/nuget/DebugDefault"
echo ================[环境变量初始化结束]
echo ================[判断文件夹是否存在]
if not exist %nuGetPath:"=% (
	echo ================[NuGet文件夹不存在开始创建]
	mkdir %nuGetPath:"=%
) else (
	echo ================[NuGet文件夹已经存在！]
)
echo ================[删除NuGet文件夹的文件]
del /f /q %nuGetPath:"=%*.*
echo ================[开始打包NuGet]
echo ================[打包Release版本]
%nugetRunFilePath:"=% pack %projectName%.csproj -symbols -properties Configuration=Release -outputdirectory %nuGetPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[打包出错]
	rem goto end
)
echo ================[重命名Release包名]
for %%a in (%nuGetPath:"=%*) do (
	echo %%a | findstr /i /c:"symbols.nupkg" > nul && set /a isReleaseSymbols=1 || set /a isReleaseSymbols=0
	if !isReleaseSymbols! EQU 1 (
		set newReleaseFileName=%releaseSymbolsFileName%
	) else (
		set newReleaseFileName=%releaseFileName%
	)
	ren %%a !newReleaseFileName!
	echo ================[重命名成功：!newReleaseFileName:"=!]
)
if "%errorlevel%" NEQ "0" (
	echo ================[重命名出错]
	rem goto end
)
echo ================[打包Debug-Symbols版本]
%nugetRunFilePath:"=% pack %projectName%.csproj -symbols -outputdirectory %nuGetPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[打包出错]
	rem goto end
)
echo ================[重命名Debug包名]
for %%a in (%nuGetPath:"=%*) do (
	echo %%a | findstr /i "Release" > nul && set /a isReleaseFile=1 || set /a isReleaseFile=0
	if !isReleaseFile! EQU 0 (
		echo %%a | findstr /i /c:"symbols.nupkg" > nul && set /a isDebugSymbols=1 || set /a isDebugSymbols=0
		if !isDebugSymbols! EQU 1 (
			set newDebugFileName=%debugSymbolsFileName%
		) else (
			set newDebugFileName=%debugFileName%
		)
		ren %%a !newDebugFileName!
		echo ================[重命名成功：!newDebugFileName:"=!]
	)
)
if "%errorlevel%" NEQ "0" (
	echo ================[重命名出错]
	rem goto end
)
echo ================[开始提交到内部nuget]
echo ================[提交到Release Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%releaseFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetReleaseSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[提交到Release Feed失败]
	rem goto end
) else (
	echo ================[提交到Release Feed成功]
)
echo ================[提交到Release-Symbols Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%releaseSymbolsFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetReleaseSymbolsSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[提交到Release-Symbols Feed失败]
	rem goto end
) else (
	echo ================[提交到Release-Symbols Feed成功]
)
echo ================[提交到Debug-Symbols Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%debugSymbolsFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetDebugSymbolsSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[提交到Debug-Symbols Feed失败]
	rem goto end
) else (
	echo ================[提交到Debug-Symbols Feed成功]
)
echo ================[提交到Debug Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%debugFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetDebugSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[提交到Debug Feed失败]
	rem goto end
) else (
	echo ================[提交到Debug Feed成功]
)
:end
echo ================[如果出现找不到路径，请检查批处理的环境变量]================
