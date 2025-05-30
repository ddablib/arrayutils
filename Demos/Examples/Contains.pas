{
 * Example code for TArrayUtils.Contains<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Contains;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Contains_Eg1;
var
  A: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  EqComparerFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;
  Assert(TArrayUtils.Contains<Integer>(2, A, EqComparerFn) = True);
  Assert(TArrayUtils.Contains<Integer>(4, A, EqComparerFn) = False);
end;

procedure Contains_Eg2;
var
  A: TArray<string>;
  EqComparerObj: IEqualityComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c');
  EqComparerObj := TDelegatedEqualityComparer<string>.Create(
    SameStr,
    function(const Value: string): Integer
    begin
      // only do this if you KNOW the hash function won't be called
      Result := 0;
    end
  );
  Assert(TArrayUtils.Contains<string>('b', A, EqComparerObj) = True);
  Assert(TArrayUtils.Contains<string>('d', A, EqComparerObj) = False);
end;

initialization

TRegistrar.Add(
  'Contains<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Contains_Eg1', @Contains_Eg1),
    TProcedureInfo.Create('Contains_Eg2', @Contains_Eg2)
  )
);

end.
