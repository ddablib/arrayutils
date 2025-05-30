{
 * Example code for TArrayUtils.Delete<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Delete;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Delete_Eg1;
var
  A, Expected: TArray<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5);

  // delete middle item
  TArrayUtils.Delete<Integer>(A, 2);
  Expected := TArray<Integer>.Create(1, 2, 4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete first item
  TArrayUtils.Delete<Integer>(A, 0);
  Expected := TArray<Integer>.Create(2, 4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete last item
  TArrayUtils.Delete<Integer>(A, 2);
  Expected := TArray<Integer>.Create(2, 4);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete invalid index < 0
  TArrayUtils.Delete<Integer>(A, -1);
  Expected := TArray<Integer>.Create(2, 4);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));

  // delete invalid index = Length(A)
  TArrayUtils.Delete<Integer>(A, Length(A));
  Expected := TArray<Integer>.Create(2, 4);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

procedure Delete_Eg2;
var
  A, Expected: TArray<Integer>;
begin
  // Delete indices 0, 2, 4 and 9. We also throw in some duplicate and out of
  // range indices to show that they are ignored.
  A := TArray<Integer>.Create(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  // the following function is identical to calling
  // TArrayUtils.Delete<Integer>(A, [0, 2, 4, 9]);
  TArrayUtils.Delete<Integer>(A, [0, 26, 2, -1, 9, 4, 9, 9, 26]);
  Expected := TArray<Integer>.Create(1, 3, 5, 6, 7, 8);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

initialization

TRegistrar.Add(
  'Delete<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Delete_Eg1', @Delete_Eg1),
    TProcedureInfo.Create('Delete_Eg2', @Delete_Eg2)
  )
);

end.
