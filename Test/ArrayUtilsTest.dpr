{
 * Delphi DUnit Test Project for DelphiDabbler.Lib.ArrayUtils.pas
 *
 * This project provides a DUnit test framework for the
 * DelphiDabbler.Lib.ArrayUtils.pas unit. This project supports only the GUI
 * version of the test framework.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

program ArrayUtilsTest;

uses
  Forms,
  GUITestRunner,
  TestFramework,
  TestArrayUtils in 'TestArrayUtils.pas',
  DelphiDabbler.Lib.ArrayUtils in '..\DelphiDabbler.Lib.ArrayUtils.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.

