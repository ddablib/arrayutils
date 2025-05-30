{
 * Example code for TArrayUtils.Chop<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Chop;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Chop_Eg1;
var
  A, ATest, ASlice, AExpectedSlice, AExpectedRemainder: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time', 'saves', 'nine');
  // slice from the start of A
  ATest := Copy(A);
  ASlice := TArrayUtils.Chop<string>(ATest, 0, 2);
  AExpectedRemainder := TArray<string>.Create('time', 'saves', 'nine');
  AExpectedSlice := TArray<string>.Create('a', 'stitch', 'in');
  Assert(TArrayUtils.Equal<string>(AExpectedRemainder, ATest, SameStr));
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // Chop in the middle of ATest
  ATest := Copy(A);
  ASlice := TArrayUtils.Chop<string>(ATest, 2, 4);
  AExpectedRemainder := TArray<string>.Create('a', 'stitch', 'nine');
  AExpectedSlice := TArray<string>.Create('in', 'time', 'saves');
  Assert(TArrayUtils.Equal<string>(AExpectedRemainder, ATest, SameStr));
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // Chop at the end of ATest
  ATest := Copy(A);
  ASlice := TArrayUtils.Chop<string>(ATest, 4, 5);
  AExpectedRemainder := TArray<string>.Create('a', 'stitch', 'in', 'time');
  AExpectedSlice := TArray<string>.Create('saves', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpectedRemainder, ATest, SameStr));
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
end;

procedure Chop_Eg2;
var
  A, ATest, ASlice, AExpectedSlice, AExpectedRemainder: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time', 'saves', 'nine');
  // slice from mid to end of A
  ATest := Copy(A);
  ASlice := TArrayUtils.Chop<string>(ATest, 3);
  AExpectedRemainder := TArray<string>.Create('a', 'stitch', 'in');
  AExpectedSlice := TArray<string>.Create('time', 'saves', 'nine');
  Assert(TArrayUtils.Equal<string>(AExpectedRemainder, ATest, SameStr));
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
  // Chop of all of ATest
  ATest := Copy(A);
  ASlice := TArrayUtils.Chop<string>(ATest, 0);
  AExpectedRemainder := TArray<string>.Create();
  AExpectedSlice := Copy(A);
  Assert(TArrayUtils.Equal<string>(AExpectedRemainder, ATest, SameStr));
  Assert(TArrayUtils.Equal<string>(AExpectedSlice, ASlice, SameStr));
end;

initialization

TRegistrar.Add(
  'Chop<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Chop_Eg1', @Chop_Eg1),
    TProcedureInfo.Create('Chop_Eg2', @Chop_Eg2)
  )
);

end.
