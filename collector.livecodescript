script "LIB_BUILD_Collector"
######################################################################################
## LIB_BUILD COLLECTOR  (13 11 2026)
## Gathers every part of the xt3d games bench and the Vibecode3D standalone into ONE folder
## you can copy to another Windows computer. Open this file in LiveCode (an empty IDE is
## enough): the window builds itself. Press Collect, pick an empty destination folder.
## The parts list is parts.txt beside this file (source <tab> destination).
## On the other computer: copy <demo>/xt3d/extension to C:\xt3d\extension, then run
## <demo>/projects/xt3D_Raylib_Livecode_Bridge/standalone/xt3d_Bench_LibMCP/xt3d_Bench_LibMCP.exe
## (Games button: every game) or <demo>/projects/Vibecode3D/standalone/VibeCode3D/.../VibeCode3D.exe.
######################################################################################

local sProjects, sHere, sCount, sBytes, sMissing

on preOpenStack
   local tPath
   put the effective filename of me into tPath
   replace "\" with "/" in tPath
   set the itemDel to "/"
   put item 1 to -2 of tPath into sHere
   put item 1 to -3 of tPath into sProjects
   set the title of me to "FOR OWNER | LIB_BUILD: press Collect, choose an empty folder"
   set the rect of me to 100, 100, 760, 420
   if there is not a button "Collect" then
      create button "Collect"
      set the rect of button "Collect" to 20, 20, 160, 50
      set the script of button "Collect" to "on mouseUp" & cr & "   Build.Collect" & cr & "end mouseUp"
   end if
   if there is not a field "Log" then
      create field "Log"
      set the rect of field "Log" to 20, 60, 640, 300
      set the vScrollbar of field "Log" to true
      set the lockText of field "Log" to true
   end if
   put "Parts from:" && sProjects & cr & "List:" && sHere & "/parts.txt" into field "Log"
end preOpenStack

on Build.Say pText
   if there is a field "Log" then put cr & pText after field "Log"
end Build.Say

-- copy every part in parts.txt into pDest (asked for when empty)
on Build.Collect pDest
   local tList, tLine, tSrc, tDst
   if pDest is empty then
      answer folder "Choose an EMPTY folder for the portable demo:"
      if it is empty then exit Build.Collect
      put it into pDest
   end if
   replace "\" with "/" in pDest
   put URL ("file:" & sHere & "/parts.txt") into tList
   replace numToChar(13) with empty in tList
   put 0 into sCount
   put 0 into sBytes
   put empty into sMissing
   set the itemDel to tab
   repeat for each line tLine in tList
      if tLine is empty or char 1 of tLine is "#" then next repeat
      put item 1 of tLine into tSrc
      if char 2 of tSrc is not ":" then put sProjects & "/" & tSrc into tSrc
      put pDest & "/" & item 2 of tLine into tDst
      if there is a folder tSrc then
         Build.CopyFolder tSrc, tDst
      else if there is a file tSrc then
         Build.CopyFile tSrc, tDst
      else
         put tSrc & cr after sMissing
      end if
      Build.Say "copied" && item 2 of tLine
   end repeat
   Build.WriteReadme pDest
   Build.Say "DONE:" && sCount && "files," && round(sBytes / 1048576, 1) && "MB ->" && pDest
   if sMissing is not empty then Build.Say "MISSING (not copied):" & cr & sMissing
   return sCount
end Build.Collect

on Build.CopyFolder pSrc, pDst
   local tF, tSub
   Build.MakeFolders pDst
   repeat for each line tF in files(pSrc)
      if tF contains "Zone.Identifier" then next repeat
      Build.CopyFile pSrc & "/" & tF, pDst & "/" & tF
   end repeat
   repeat for each line tSub in folders(pSrc)
      if tSub is "." or tSub is ".." or tSub is ".git" or tSub is "__pycache__" then next repeat
      Build.CopyFolder pSrc & "/" & tSub, pDst & "/" & tSub
   end repeat
end Build.CopyFolder

on Build.CopyFile pSrc, pDst
   local tData
   set the itemDel to "/"
   Build.MakeFolders item 1 to -2 of pDst
   put URL ("binfile:" & pSrc) into tData
   put tData into URL ("binfile:" & pDst)
   add 1 to sCount
   add the length of tData to sBytes
end Build.CopyFile

on Build.MakeFolders pPath
   local tSoFar, tPart
   set the itemDel to "/"
   repeat for each item tPart in pPath
      put tPart after tSoFar
      if tPart is not empty and char -1 of tSoFar is not ":" and tSoFar is not "/" and tSoFar is not "//" then
         if there is not a folder tSoFar then create folder tSoFar
      end if
      put "/" after tSoFar
   end repeat
end Build.MakeFolders

on Build.WriteReadme pDest
   local t
   put "LIB_ARRAY portable demo, collected" && the long date && the long time & cr & cr into t
   put "1. Copy the folder xt3d\extension to C:\xt3d\extension (the xt3d bench loads raylib from there)." & cr after t
   put "2. xt3d games bench (every game in LIB_GAMES): projects\xt3D_Raylib_Livecode_Bridge\standalone\xt3d_Bench_LibMCP\xt3d_Bench_LibMCP.exe, press Games, click a game." & cr after t
   put "3. Vibecode3D: projects\Vibecode3D\standalone\VibeCode3D\Windows x86-64\VibeCode3D.exe (its built-in games; new LIB_GAMES cards need installing from the IDE or LIB_TEST)." & cr after t
   put "4. Test notes: projects\LIB_TEST\README.md. Write what you see in a text file and bring it back." & cr after t
   put t into URL ("file:" & pDest & "/README_FIRST.txt")
end Build.WriteReadme
