{
 * Example code for TArrayUtils.Equal<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Equal;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Equal_Eg1;
var
  A, B, C, D, E1, E2: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  B := TArray<Integer>.Create(1, 2, 3);
  C := TArray<Integer>.Create(1, 2);
  D := TArray<Integer>.Create(1, 5, 7);
  E1 := TArray<Integer>.Create();        // empty
  E2 := TArray<Integer>.Create();        // empty
  EqComparerFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;
  Assert(TArrayUtils.Equal<Integer>(A, B, EqComparerFn) = True);
  Assert(TArrayUtils.Equal<Integer>(A, C, EqComparerFn) = False);
  Assert(TArrayUtils.Equal<Integer>(A, D, EqComparerFn) = False);
  Assert(TArrayUtils.Equal<Integer>(A, E1, EqComparerFn) = False);
  Assert(TArrayUtils.Equal<Integer>(E1, E2, EqComparerFn) = True);
end;

procedure Equal_Eg2;
var
  A, B, C, D, E1, E2: TArray<string>;
  EqComparerObj: IEqualityComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c');
  B := TArray<string>.Create('a', 'b', 'c');
  C := TArray<string>.Create('a', 'b');
  D := TArray<string>.Create('a', 'd', 'f');
  E1 := TArray<string>.Create();        // empty
  E2 := TArray<string>.Create();        // empty
  EqComparerObj := TDelegatedEqualityComparer<string>.Create(
    SameStr,
    function (const Value: string): Integer
    begin
      // This is only safe because the hash function isn't called by Equal
      Result := 0;
    end
  );
  Assert(TArrayUtils.Equal<string>(A, B, EqComparerObj) = True);
  Assert(TArrayUtils.Equal<string>(A, C, EqComparerObj) = False);
  Assert(TArrayUtils.Equal<string>(A, D, EqComparerObj) = False);
  Assert(TArrayUtils.Equal<string>(A, E1, EqComparerObj) = False);
  Assert(TArrayUtils.Equal<string>(E1, E2, EqComparerObj) = True);
end;

initialization

TRegistrar.Add(
  'Equal<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Equal_Eg1', @Equal_Eg1),
    TProcedureInfo.Create('Equal_Eg2', @Equal_Eg2)
  )
);

end.
