{
 * Example code for TArrayUtils.CopySorted<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit CopySorted;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure CopySorted_Eg1;
var
  A, Got, Expected: TArray<Integer>;
  ReverseComparerFn: TComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  ReverseComparerFn := function(const Left, Right: Integer): Integer
    begin
      // reverse sort
      Result := Right - Left;
    end;
  Got := TArrayUtils.CopySorted<Integer>(A, ReverseComparerFn);
  Expected := TArray<Integer>.Create(4, 3, 3, 2, 2, 2, 1);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

procedure CopySorted_Eg2;
var
  A, Got, Expected: TArray<string>;
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
  Got := TArrayUtils.CopySorted<string>(A, ComparerObj);
  Expected := TArray<string>.Create(
    'and', 'beaky', 'dave', 'dee', 'dozy', 'mick', 'titch'
  );
  Assert(TArrayUtils.Equal<string>(Expected, Got, SameStr));
end;

initialization

TRegistrar.Add(
  'CopySorted<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('CopySorted_Eg1', @CopySorted_Eg1),
    TProcedureInfo.Create('CopySorted_Eg2', @CopySorted_Eg2)
  )
);

end.
