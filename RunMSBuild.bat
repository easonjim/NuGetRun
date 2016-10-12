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
::MSBuild路径
set mSBuildPath="C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
::编译输出目录
set debugOutputPath="bin\Debug"
set releaseOutputPaht="bin\Release"
::编译平台(Any CPU,x86,x64)
set debugPlatform="Any CPU"
set releasePlatform="Any CPU"
::生成xml文档
set debugGenerateDocumentation=true
set releaseGenerateDocumentation=true
::xml文档输出路径
set debugDocumentationFile="bin\Debug\"%projectName%".xml"
set releaseDocumentationFile="bin\Release\"%projectName%".xml"
::输出pdb文件
set debugSymbols=true
set releaseSymbols=true
echo ================[环境变量初始化结束]
echo ================[删除编译文件]
del /f /q %debugOutputPath:"=%\*.*
del /f /q %releaseOutputPaht:"=%\*.*
echo ================[删除编译文件结束]
echo ================[正在编译Debug版本]
%mSBuildPath:"=% %projectName:"=%.csproj /p:OutputPath=%debugOutputPath:"=%;Platform=%debugPlatform%;Configuration=Debug;GenerateDocumentation=%debugGenerateDocumentation%;DocumentationFile=%debugDocumentationFile:"=%;DebugSymbols=%debugSymbols%
if "%errorlevel%" NEQ "0" (
	echo ================[编译Debug版本出错]
	goto end
) else (
	echo ================[编译Debug版本成功]
)
echo ================[正在编译Release版本]
%mSBuildPath:"=% %projectName:"=%.csproj /p:OutputPath=%releaseOutputPaht:"=%;Platform=%releasePlatform%;Configuration=Release;GenerateDocumentation=%releaseGenerateDocumentation%;DocumentationFile=%releaseDocumentationFile:"=%;DebugSymbols=%releaseSymbols%
if "%errorlevel%" NEQ "0" (
	echo ================[编译Release版本出错]
	goto end
) else (
	echo ================[编译Release版本成功]
)
:end
echo ================[如果出现找不到路径，请检查批处理的环境变量]================
pause


