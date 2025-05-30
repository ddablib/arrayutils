{
 * Example code for TArrayUtils.UnShift<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit UnShift;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure UnShift_Eg;
var
  A, Expected: TArray<string>;
begin
  A := TArray<string>.Create();

  TArrayUtils.UnShift<string>(A, 'foo');
  Expected := TArray<string>.Create('foo');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  TArrayUtils.UnShift<string>(A, 'bar');
  Expected := TArray<string>.Create('bar', 'foo');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  TArrayUtils.UnShift<string>(A, 'baz');
  Expected := TArray<string>.Create('baz', 'bar', 'foo' );
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));
end;

initialization

TRegistrar.Add(
  'UnShift<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('UnShift_Eg', @UnShift_Eg)
  )
);

end.
