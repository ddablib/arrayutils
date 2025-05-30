{
 * Example code for TArrayUtils.Pop<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Pop;

interface

implementation

uses
  SysUtils,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Pop_Eg;
var
  A, Expected: TArray<string>;
begin
  A := TArray<string>.Create('a', 'stitch', 'in', 'time');

  Expected := TArray<string>.Create('a', 'stitch', 'in');
  Assert(TArrayUtils.Pop<string>(A) = 'time');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create('a', 'stitch');
  Assert(TArrayUtils.Pop<string>(A) = 'in');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create('a');
  Assert(TArrayUtils.Pop<string>(A) = 'stitch');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));

  Expected := TArray<string>.Create();
  Assert(TArrayUtils.Pop<string>(A) = 'a');
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));
end;

initialization

TRegistrar.Add(
  'Pop<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Pop_Eg', @Pop_Eg)
  )
);

end.
