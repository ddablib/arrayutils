{
 * Example code for TArrayUtils.DeDup<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeDup;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure DeDup_Eg;
var
  A, B, Expected: TArray<string>;
begin
  A := TArray<string>.Create('Foo', 'Bar', 'foo', 'Foo', 'BAR');
  B := TArrayUtils.DeDup<string>(A, SameText);
  Expected := TArray<string>.Create('Foo', 'Bar');
  Assert(TArrayUtils.Equal<string>(Expected, B, SameText));
end;

initialization

TRegistrar.Add(
  'DeDup<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeDup_Eg', @DeDup_Eg)
  )
);

end.
