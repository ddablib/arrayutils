{
 * Example code for TArrayUtils.Compare<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Compare;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Compare_Eg1;
var
  A, B, C, D, E: TArray<Integer>;
  ComparerFn: TComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  B := TArray<Integer>.Create(1, 2, 3);
  C := TArray<Integer>.Create(1, 2);
  D := TArray<Integer>.Create(1, 5, 7);
  E := TArray<Integer>.Create();        // empty
  ComparerFn := function(const Left, Right: Integer): Integer
    begin
      Result := Left - Right;
    end;
  Assert(TArrayUtils.Compare<Integer>(A, B, ComparerFn) = 0);
  Assert(TArrayUtils.Compare<Integer>(A, C, ComparerFn) > 0);
  Assert(TArrayUtils.Compare<Integer>(A, D, ComparerFn) < 0);
  Assert(TArrayUtils.Compare<Integer>(A, E, ComparerFn) > 0);
end;

procedure Compare_Eg2;
var
  A, B, C, D, E: TArray<string>;
  ComparerObj: IComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c');
  B := TArray<string>.Create('a', 'b', 'c');
  C := TArray<string>.Create('a', 'b');
  D := TArray<string>.Create('a', 'd', 'f');
  E := TArray<string>.Create();        // empty
  ComparerObj := TDelegatedComparer<string>.Create(CompareStr);
  Assert(TArrayUtils.Compare<string>(A, B, ComparerObj) = 0);
  Assert(TArrayUtils.Compare<string>(A, C, ComparerObj) > 0);
  Assert(TArrayUtils.Compare<string>(A, D, ComparerObj) < 0);
  Assert(TArrayUtils.Compare<string>(A, E, ComparerObj) > 0);
end;

initialization

TRegistrar.Add(
  'Compare<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Compare_Eg1', @Compare_Eg1),
    TProcedureInfo.Create('Compare_Eg2', @Compare_Eg2)
  )
);

end.
