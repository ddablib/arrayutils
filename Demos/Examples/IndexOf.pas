{
 * Example code for TArrayUtils.IndexOf<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit IndexOf;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure IndexOf_Eg1;
var
  A: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  EqComparerFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;
  Assert(TArrayUtils.IndexOf<Integer>(3, A, EqComparerFn) = 2);
  Assert(TArrayUtils.IndexOf<Integer>(5, A, EqComparerFn) = -1);
end;

procedure IndexOf_Eg2;
var
  A: TArray<string>;
  EqComparerObj: IEqualityComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c', 'd', 'c', 'a');
  EqComparerObj := TDelegatedEqualityComparer<string>.Create(
    SameStr,
    function(const Value: string): Integer
    begin
      // only do this if you KNOW the hash function won't be called
      Result := 0;
    end
  );
  Assert(TArrayUtils.IndexOf<string>('a', A, EqComparerObj) = 0);
  Assert(TArrayUtils.IndexOf<string>('x', A, EqComparerObj) = -1);
end;

initialization

TRegistrar.Add(
  'IndexOf<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('IndexOf_Eg1', @IndexOf_Eg1),
    TProcedureInfo.Create('IndexOf_Eg2', @IndexOf_Eg2)
  )
);

end.
