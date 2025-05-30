{
 * Example code for TArrayUtils.Min<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Min;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Min_Eg1;
var
  A: TArray<Integer>;
  ComparerFn: TComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  ComparerFn := function(const Left, Right: Integer): Integer
    begin
      Result := Left - Right;
    end;
  Assert(TArrayUtils.Min<Integer>(A, ComparerFn) = 1);
end;

procedure Min_Eg2;
var
  A: TArray<string>;
  ComparerObj: IComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c', 'd', 'c', 'a');
  ComparerObj := TDelegatedComparer<string>.Create(CompareStr);
  Assert(TArrayUtils.Min<string>(A, ComparerObj) = 'a');
end;

initialization

TRegistrar.Add(
  'Min<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Min_Eg1', @Min_Eg1),
    TProcedureInfo.Create('Min_Eg2', @Min_Eg2)
  )
);

end.
