{
 * Example code for TArrayUtils.Shift<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Shift;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Shift_Eg;
var
  A, Expected: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time');

  Expected := TArray<string>.Create('stitch', 'in', 'time');
  Assert(TArrayUtils.Shift<string>(A) = 'a');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create('in', 'time');
  Assert(TArrayUtils.Shift<string>(A) = 'stitch');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create('time');
  Assert(TArrayUtils.Shift<string>(A) = 'in');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create();
  Assert(TArrayUtils.Shift<string>(A) = 'time');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));
end;

initialization

TRegistrar.Add(
  'Shift<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Shift_Eg', @Shift_Eg)
  )
);

end.
