$vs_location = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.15.26726\bin\Hostx86\x86\";
$compiler_location = "$($vs_location)cl.exe";
$linker_location = "$($vs_location)link.exe";

$plugins = (Get-Content plugins.json) -join "`n" | ConvertFrom-Json | Select -expand plugins

$bakkesmod_sdk_include = "F:\Bakkesmod\development\BakkesMod-rewrite\BakkesMod Rewrite";
$bakkesmod_sdk_lib = "F:\Bakkesmod\development\BakkesMod-rewrite\Release";



Remove-Item .\tmp -Force -Recurse
foreach($plugin in $plugins)
{
    #Clean tmp folder so we can build into it
    New-Item -ItemType directory -Path .\tmp

    $files = (Get-ChildItem -Path "./sources/$($plugin.submodule)/$($plugin.sourcedir)/" -Recurse -Filter "*.cpp" | Select-Object FullName | foreach{$($_.FullName)}) #-join " " Do not -join, if using & it will treat the entire $files as 1 argument
    
    echo "Compiling $($plugin.dllname)..."
    & $compiler_location  /c /I"$($bakkesmod_sdk_include)" /nologo /W3 /WX- /diagnostics:classic /sdl /O2 /Oi /Oy- /GL /D _MBCS /D _WINDLL /D _MBCS /D IS_PLUGIN /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /Fo"tmp\\" /Gd /TP /analyze- /FC /errorReport:prompt $files | out-null
    echo "Compiled, linking..."
    & $linker_location /ERRORREPORT:PROMPT /OUT:"tmp\$($plugin.dllname)" /NOLOGO /LIBPATH:"$($bakkesmod_sdk_lib)" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed /OPT:REF /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /MACHINE:X86 /SAFESEH /DLL tmp\*.obj | out-null
    echo "Linked"
    
    if(![System.IO.File]::Exists("tmp\$($plugin.dllname)"))
    {
        echo "WARNING: $($plugin.dllname) DOES NOT EXIST!!! COMPILATION FAILED!"
    } 
    else
    {
        echo "Moving files..."
        Move-Item -Path "tmp\$($plugin.dllname)" -Destination "plugins\$($plugin.dllname)" -Force
        Copy-Item -Path "./sources/$($plugin.submodule)/$($plugin.settings)" -Destination "plugins\settings\$([System.IO.Path]::GetFileName($plugin.settings))" -Force
    }
    Remove-Item .\tmp -Force -Recurse
}
#& $compiler_location  /c /I"F:\Bakkesmod\development\BakkesMod-rewrite\BakkesMod Rewrite" /Zi /nologo /W3 /WX- /diagnostics:classic /sdl /O2 /Oi /Oy- /GL /D _MBCS /D _WINDLL /D _MBCS /D IS_PLUGIN /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /Fo"Release\\" /Gd /TP /analyze- /FC /errorReport:prompt MrSuluPlugin/MrSuluPlugin.cpp
#& $linker_location /ERRORREPORT:PROMPT /OUT:"Release\MrSuluPlugin.dll" /NOLOGO /LIBPATH:"F:\Bakkesmod\development\BakkesMod-rewrite\Release" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed /OPT:REF /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /MACHINE:X86 /SAFESEH /DLL Release\MrSuluPlugin.obj
