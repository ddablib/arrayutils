{
 * Example code for TArrayUtils.First<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit First;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure First_Eg;
var
  A: TArray<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  Assert(TArrayUtils.First<Integer>(A) = 1);
end;

initialization

TRegistrar.Add(
  'First<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('First_Eg', @First_Eg)
  )
);

end.
