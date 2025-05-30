{
 * Example code for TArrayUtils.Max<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Max;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Max_Eg1;
var
  A: TArray<Integer>;
  ComparerFn: TComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  ComparerFn := function(const Left, Right: Integer): Integer
    begin
      Result := Left - Right;
    end;
  Assert(TArrayUtils.Max<Integer>(A, ComparerFn) = 4);
end;

procedure Max_Eg2;
var
  A: TArray<string>;
  ComparerObj: IComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c', 'd', 'c', 'a');
  ComparerObj := TDelegatedComparer<string>.Create(CompareStr);
  Assert(TArrayUtils.Max<string>(A, ComparerObj) = 'd');
end;

initialization

TRegistrar.Add(
  'Max<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Max_Eg1', @Max_Eg1),
    TProcedureInfo.Create('Max_Eg2', @Max_Eg2)
  )
);

end.
