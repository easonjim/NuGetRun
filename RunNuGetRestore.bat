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
	goto end
) else (
	echo ================[查找项目名称成功]
)
if "%projectName%"=="null" (
	echo ================[获取项目名称出错]
	goto end
) else (
	echo ================[获取项目名称成功]
	echo ================[项目名称：%projectName%]
)
set nugetRunFilePath=%cd%"\NuGetRun\nuget.exe"
set packagesconfigFilePath="packages.config"
set packagesPath="..\packages"
set nugetReleaseSource="http://localhost:8001/nuget/ReleaseDefault"
set nugetReleaseSymbolsSource="http://localhost:8001/nuget/SymbolsReleaseDefault"
set nugetDebugSymbolsSource="http://localhost:8001/nuget/SymbolsDebugDefault"
set nugetDebugSource="http://localhost:8001/nuget/DebugDefault"
echo ================[环境变量初始化结束]
echo ================[正在还原NuGet包]
%nugetRunFilePath:"=% restore -source %nugetReleaseSource:"=% -configfile %packagesconfigFilePath:"=% -packagesdirectory %packagesPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[还原NuGet包出错]
	rem goto end
) else (
	echo ================[还原NuGet包成功]
)
:end
echo ================[如果出现找不到路径，请检查批处理的环境变量]================
pause & exit