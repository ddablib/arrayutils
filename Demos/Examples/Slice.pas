{
 * Example code for TArrayUtils.Slice<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Slice;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Slice_Eg1;
var
  A, ASlice, AExpectedSlice: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time', 'saves', 'nine');
  // slice from the start of A
  ASlice := TArrayUtils.Slice<string>(A, 0, 2);
  AExpectedSlice := TArray<string>.Create('a', 'stitch', 'in');
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // slice in the middle of A
  ASlice := TArrayUtils.Slice<string>(A, 2, 4);
  AExpectedSlice := TArray<string>.Create('in', 'time', 'saves');
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // slice at the end of A
  ASlice := TArrayUtils.Slice<string>(A, 4, 5);
  AExpectedSlice := TArray<string>.Create('saves', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
end;

procedure Slice_Eg2;
var
  A, ASlice, AExpectedSlice: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time', 'saves', 'nine');
  // slice from mid to end of A
  ASlice := TArrayUtils.Slice<string>(A, 3);
  AExpectedSlice := TArray<string>.Create('time', 'saves', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // slice of all of A
  ASlice := TArrayUtils.Slice<string>(A, 0);
  AExpectedSlice := A;
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
end;

initialization

TRegistrar.Add(
  'Slice<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Slice_Eg1', @Slice_Eg1),
    TProcedureInfo.Create('Slice_Eg2', @Slice_Eg2)
  )
);

end.
