{
 * Example code for TArrayUtils.CopyReversed<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit CopyReversed;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure CopyReversed_Eg;
var
  A, R, Expected: TArray<Integer>;
begin
  A := TArray<Integer>.Create(0, 99, 42, 56);
  R := TArrayUtils.CopyReversed<Integer>(A);
  Expected := TArray<Integer>.Create(56, 42, 99, 0);
  Assert(TArrayUtils.Equal<Integer>(Expected, R));
end;

initialization

TRegistrar.Add(
  'CopyReversed<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('CopyReversed_Eg', @CopyReversed_Eg)
  )
);

end.
