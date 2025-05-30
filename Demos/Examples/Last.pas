{
 * Example code for TArrayUtils.Last<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Last;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Last_Eg;
var
  A: TArray<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  Assert(TArrayUtils.Last<Integer>(A) = 3);
end;

initialization

TRegistrar.Add(
  'Last<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Last_Eg', @Last_Eg)
  )
);

end.
