{
 * Example code for TArrayUtils.Push<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Push;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Push_Eg;
var
  A, Expected: TArray<string>;
begin
  A := TArray<string>.Create();

  TArrayUtils.Push<string>(A, 'foo');
  Expected := TArray<string>.Create('foo');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  TArrayUtils.Push<string>(A, 'bar');
  Expected := TArray<string>.Create('foo', 'bar');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  TArrayUtils.Push<string>(A, 'baz');
  Expected := TArray<string>.Create('foo', 'bar', 'baz');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));
end;

initialization

TRegistrar.Add(
  'Push<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Push_Eg', @Push_Eg)
  )
);

end.
