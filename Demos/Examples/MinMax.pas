{
 * Example code for TArrayUtils.MinMax<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit MinMax;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;


procedure MinMax_Eg1;
var
  A: TArray<Integer>;
  MinVal, MaxVal: Integer;
  ComparerFn: TComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  ComparerFn := function(const Left, Right: Integer): Integer
    begin
      Result := Left - Right;
    end;
  TArrayUtils.MinMax<Integer>(A, ComparerFn, MinVal, MaxVal);
  Assert(MinVal = 1);
  Assert(MaxVal = 4);
end;

procedure MinMax_Eg2;
var
  A: TArray<string>;
  MinVal, MaxVal: string;
  ComparerObj: IComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c', 'd', 'c', 'a');
  ComparerObj := TDelegatedComparer<string>.Create(CompareStr);
  TArrayUtils.MinMax<string>(A, ComparerObj, MinVal, MaxVal);
  Assert(MinVal = 'a');
  Assert(MaxVal = 'd');
end;

initialization

TRegistrar.Add(
  'MinMax<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('MinMax_Eg1', @MinMax_Eg1),
    TProcedureInfo.Create('MinMax_Eg2', @MinMax_Eg2)
  )
);

end.
