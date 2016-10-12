# NuGetRun
NuGet自动打包和推送批处理  
平台：Windows  
nuget.exe--  
RunMSBuild.bat--MSBuild生成项目  
RunNuGetPackage.bat--NuGet自动打包并推送到指定的Feed  
RunNuGetRestore.bat--NuGet包还原  
#####RunNuGetPackage.bat的配置说明：  
nugetApiKey//NuGet的apikey  
其余是对应NuGet的Feed地址，根据需要去除  
####项目集成说明  
1、新建NuGetRun文件夹，并拷贝全部的文件进去  
2、提交SVN或者Git时记得一并提交，好让CI能自动处理  
目录结构如下：  
│  
├─NuGetRun  
│　　　　nuget.exe  
│　　　　RunMSBuild.bat  
│　　　　RunNuGetPackage.bat  
│　　　　RunNuGetRestore.bat  
│  
