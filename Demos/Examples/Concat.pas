{
 * Example code for TArrayUtils.Concat<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Concat;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Concat_Eg;
var
  A, B, Got, Expected: TArray<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4);
  B := TArray<Integer>.Create(42, 56);
  Got := TArrayUtils.Concat<Integer>(A, B);
  Expected := TArray<Integer>.Create(1, 2, 3, 4, 42, 56);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

initialization

TRegistrar.Add(
  'Concat<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Concat_Eg', @Concat_Eg)
  )
);

end.
