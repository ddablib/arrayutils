{
 * Example code for TArrayUtils.Insert<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Insert;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Insert_Eg1;
var
  A, Expected: TArray<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5);

  TArrayUtils.Insert<Integer>(A, 6, 2);  // insert before middle item
  Expected := TArray<Integer>.Create(1, 2, 6, 3, 4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  TArrayUtils.Insert<Integer>(A, 7, 0);  // insert before first item
  Expected := TArray<Integer>.Create(7, 1, 2, 6, 3, 4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  TArrayUtils.Insert<Integer>(A, 8, 6);  // insert before last item
  Expected := TArray<Integer>.Create(7, 1, 2, 6, 3, 4, 8, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  TArrayUtils.Insert<Integer>(A, 9, 8);  // insert after last item
  Expected := TArray<Integer>.Create(7, 1, 2, 6, 3, 4, 8, 5, 9);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

procedure Insert_Eg2;
var
  ATarget, AInsert, AExpected: TArray<Integer>;
begin
  AInsert := TArray<Integer>.Create(42, 56);

  // Insert non-empty array at end of ATarget non-empty array
  ATarget := TArray<Integer>.Create(1, 2, 3, 4, 5);
  TArrayUtils.Insert<Integer>(ATarget, AInsert, Length(ATarget));
  AExpected := TArray<Integer>.Create(1, 2, 3, 4, 5, 42, 56);
  Assert(TArrayUtils.Equal<Integer>(AExpected, ATarget));

  // Insert non-empty array in middle of non-empty array
  ATarget := TArray<Integer>.Create(2, 4, 6, 8, 10);
  TArrayUtils.Insert<Integer>(ATarget, AInsert, 3);
  AExpected := TArray<Integer>.Create(2, 4, 6, 42, 56, 8, 10);
  Assert(TArrayUtils.Equal<Integer>(AExpected, ATarget));

  // Insert non-empty array before start of ATarget non-empty array
  ATarget := TArray<Integer>.Create(1, 2, 3);
  TArrayUtils.Insert<Integer>(ATarget, AInsert, 0);
  AExpected := TArray<Integer>.Create(42, 56, 1, 2, 3);
  Assert(TArrayUtils.Equal<Integer>(AExpected, ATarget));
end;

initialization

TRegistrar.Add(
  'Insert<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Insert_Eg1', @Insert_Eg1),
    TProcedureInfo.Create('Insert_Eg2', @Insert_Eg2)
  )
);

end.
