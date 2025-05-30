{
 * Example code for TArrayUtils.Reverse<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Reverse;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Reverse_Eg;
var
  A, Expected: TArray<Integer>;
begin
  A := TArray<Integer>.Create(0, 99, 42, 56);
  TArrayUtils.Reverse<Integer>(A);
  Expected := TArray<Integer>.Create(56, 42, 99, 0);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

initialization

TRegistrar.Add(
  'Reverse<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Reverse_Eg', @Reverse_Eg)
  )
);

end.
