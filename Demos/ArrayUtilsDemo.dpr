{
 * Demo project for the DelphiDabbler.Lib.ArrayUtils unit.
 *
 * Contains copies the example code of all TArrayUtils methods included in the
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * This is a console application.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

program ArrayUtilsDemo;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils in '..\DelphiDabbler.Lib.ArrayUtils.pas',
  Registrar in 'Registrar.pas',
  Chop in 'Examples\Chop.pas',
  Compare in 'Examples\Compare.pas',
  Concat in 'Examples\Concat.pas',
  Contains in 'Examples\Contains.pas',
  Copy in 'Examples\Copy.pas',
  CopyReversed in 'Examples\CopyReversed.pas',
  CopySorted in 'Examples\CopySorted.pas',
  DeDup in 'Examples\DeDup.pas',
  Delete in 'Examples\Delete.pas',
  DeleteAndFree in 'Examples\DeleteAndFree.pas',
  DeleteAndFreeRange in 'Examples\DeleteAndFreeRange.pas',
  DeleteAndRelease in 'Examples\DeleteAndRelease.pas',
  DeleteAndReleaseRange in 'Examples\DeleteAndReleaseRange.pas',
  DeleteRange in 'Examples\DeleteRange.pas',
  Equal in 'Examples\Equal.pas',
  EqualStart in 'Examples\EqualStart.pas',
  Every in 'Examples\Every.pas',
  FindAll in 'Examples\FindAll.pas',
  FindAllIndices in 'Examples\FindAllIndices.pas',
  FindDef in 'Examples\FindDef.pas',
  FindIndex in 'Examples\FindIndex.pas',
  FindLastDef in 'Examples\FindLastDef.pas',
  FindLastIndex in 'Examples\FindLastIndex.pas',
  First in 'Examples\First.pas',
  ForEach in 'Examples\ForEach.pas',
  IndexOf in 'Examples\IndexOf.pas',
  IndicesOf in 'Examples\IndicesOf.pas',
  Insert in 'Examples\Insert.pas',
  Last in 'Examples\Last.pas',
  LastIndexOf in 'Examples\LastIndexOf.pas',
  Max in 'Examples\Max.pas',
  Min in 'Examples\Min.pas',
  MinMax in 'Examples\MinMax.pas',
  OccurrencesOf in 'Examples\OccurrencesOf.pas',
  Pick in 'Examples\Pick.pas',
  Pop in 'Examples\Pop.pas',
  PopAndFree in 'Examples\PopAndFree.pas',
  PopAndRelease in 'Examples\PopAndRelease.pas',
  Push in 'Examples\Push.pas',
  Reduce in 'Examples\Reduce.pas',
  Reverse in 'Examples\Reverse.pas',
  Shift in 'Examples\Shift.pas',
  ShiftAndFree in 'Examples\ShiftAndFree.pas',
  ShiftAndRelease in 'Examples\ShiftAndRelease.pas',
  Slice in 'Examples\Slice.pas',
  Some in 'Examples\Some.pas',
  Sort in 'Examples\Sort.pas',
  Transform in 'Examples\Transform.pas',
  TryFind in 'Examples\TryFind.pas',
  TryFindLast in 'Examples\TryFindLast.pas',
  UnShift in 'Examples\UnShift.pas';

var
  MethodName: string;
  MethodTitle: string;
  ProcInfo: TProcedureInfo;
  ProcTitle: string;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    for MethodName in TRegistrar.MethodNames do
    begin
      MethodTitle := 'TArrayUtils.' + MethodName;
      Writeln(MethodTitle);
      Writeln(StringOfChar('=', Length(MethodTitle)));
      Writeln;
      for ProcInfo in TRegistrar.GetProcs(MethodName) do
      begin
        ProcTitle := 'Running ' + ProcInfo.Name;
        Writeln(ProcTitle);
        Writeln(StringOfChar('-', Length(ProcTitle)));
        Writeln;
        // Call procedure
        ProcInfo.Proc;
        Writeln('DONE');
        Writeln;
      end;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Writeln;
  Writeln('END OF DEMO: press enter to exit');
  Readln;
end.
