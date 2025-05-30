{
 * Example code for TArrayUtils.Sort<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Sort;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Sort_Eg1;
var
  A, Expected: TArray<Integer>;
  ReverseComparerFn: TComparison<Integer>;
begin
  ReverseComparerFn := function(const Left, Right: Integer): Integer
    begin
      Result := Right - Left;
    end;
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  TArrayUtils.Sort<Integer>(A, ReverseComparerFn);
  Expected := TArray<Integer>.Create(4, 3, 3, 2, 2, 2, 1);
  Assert(TArrayUtils.Equal<Integer>(Expected, A));
end;

procedure Sort_Eg2;
var
  A, Expected: TArray<string>;
  ComparerObj: IComparer<string>;
begin
  ComparerObj := TDelegatedComparer<string>.Create(
    function (const Left, Right: string): Integer
    begin
      Result := CompareStr(Left, Right);
    end
  );
  A := TArray<string>.Create(
    'dave', 'dee', 'dozy', 'beaky', 'mick', 'and', 'titch'
  );
  TArrayUtils.Sort<string>(A, ComparerObj);
  Expected := TArray<string>.Create(
    'and', 'beaky', 'dave', 'dee', 'dozy', 'mick', 'titch'
  );
  Assert(TArrayUtils.Equal<string>(Expected, A, SameStr));
end;

initialization

TRegistrar.Add(
  'Sort<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Sort_Eg1', @Sort_Eg1),
    TProcedureInfo.Create('Sort_Eg2', @Sort_Eg2)
  )
);

end.
