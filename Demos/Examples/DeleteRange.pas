{
 * Example code for TArrayUtils.DeleteRange<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeleteRange;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure DeleteRange_Eg1;
var
  A, B, Expected: TArray<Integer>;
begin
  // We have to copy B to get round an obscure Delphi bug that seems to optimise
  // multiple TArray<Integer>.Create calls for the same elements.
  B := TArray<Integer>.Create(1, 2, 3, 4, 5);

  // delete 1st three elements
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, 0, 2);
  Expected := TArray<Integer>.Create(4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete 3 elements from index 1
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, 1, 3);
  Expected := TArray<Integer>.Create(1, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete last 3 elements
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, 2);
  // last index not required: if provided provided Pred(Length(A))
  Expected := TArray<Integer>.Create(1, 2);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

procedure DeleteRange_Eg2;
var
  A, B, Expected: TArray<Integer>;
begin
  // We have to copy B to get round an obscure Delphi bug that seems to optimise
  // repeated TArray<Integer>.Create calls for the same elements.
  B := TArray<Integer>.Create(1, 2, 3, 4, 5);
  // delete from start to index 2, providing negative start index
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, -3, 2);
  Expected := TArray<Integer>.Create(4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete from index 2 to end of array, providing a very large end index
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, 2, 42);
  Expected := TArray<Integer>.Create(1, 2);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete nothing because start index > end index
  A := Copy(B);
  TArrayUtils.DeleteRange<Integer>(A, 3, 2);
  Expected := TArray<Integer>.Create(1, 2, 3, 4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

initialization

TRegistrar.Add(
  'DeleteRange<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeleteRange_Eg1', @DeleteRange_Eg1),
    TProcedureInfo.Create('DeleteRange_Eg2', @DeleteRange_Eg2)
  )
);

end.
