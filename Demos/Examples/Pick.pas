{
 * Example code for TArrayUtils.Pick<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Pick;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Pick_Eg;
var
  A, AGot, AExpected: TArray<string>;
  Indices: TArray<Integer>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time', 'saves', 'nine');

  // extract a single element of A
  AGot := TArrayUtils.Pick<string>(A, [2]);
  AExpected := TArray<string>.Create('in');
  Assert(TArrayUtils.Equal<string>(AExpected, AGot, SameStr));

  // Pick the elements of A with odd indices, in the original order
  AGot := TArrayUtils.Pick<string>(A, [1, 3, 5]);
  AExpected := TArray<string>.Create('stitch', 'time', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpected, AGot, SameStr));

  // Pick one or more copies of specified elements of A, in a different order
  // to their order in A
  AGot := TArrayUtils.Pick<string>(A, [5, 3, 1, 5]);
  AExpected := TArray<string>.Create('nine', 'time', 'stitch', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpected, AGot, SameStr));

  // Pick two unique elements of A, ignoring out of range elements
  AGot := TArrayUtils.Pick<string>(A, [0, -1, Length(A), Length(A)-1]);
  AExpected := TArray<string>.Create('a', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpected, AGot, SameStr));

  // Return elements in the same order they appear in A, with no duplicates
  Indices := TArrayUtils.CopySorted<Integer>(
    TArrayUtils.DeDup<Integer>([3, 1, 2, 2, 3, 2])
  );
  AGot := TArrayUtils.Pick<string>(A, Indices);
  AExpected := TArray<string>.Create('stitch', 'in', 'time');
  Assert(TArrayUtils.Equal<string>(AExpected, AGot, SameStr));
end;

initialization

TRegistrar.Add(
  'Pick<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Pick_Eg', @Pick_Eg)
  )
);

end.
