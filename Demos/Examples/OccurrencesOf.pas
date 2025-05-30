{
 * Example code for TArrayUtils.OccurrencesOf<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit OccurrencesOf;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure OccurrencesOf_Eg1;
var
  A: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 2, 3, 2);
  EqComparerFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;
  Assert(TArrayUtils.OccurrencesOf<Integer>(2, A, EqComparerFn) = 3);
  Assert(TArrayUtils.OccurrencesOf<Integer>(5, A, EqComparerFn) = 0);
end;

procedure OccurrencesOf_Eg2;
var
  A: TArray<string>;
  EqComparerObj: IEqualityComparer<string>;
begin
  A := TArray<string>.Create('A', 'B', 'C', 'd', 'c', 'a');
  EqComparerObj := TDelegatedEqualityComparer<string>.Create(
    SameText,
    function(const Value: string): Integer
    begin
      // only do this if you KNOW the hash function won't be called
      Result := 0;
    end
  );
  Assert(TArrayUtils.OccurrencesOf<string>('C', A, EqComparerObj) = 2);
  Assert(TArrayUtils.OccurrencesOf<string>('x', A, EqComparerObj) = 0);
end;

initialization

TRegistrar.Add(
  'OccurrencesOf<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('OccurrencesOf_Eg1', @OccurrencesOf_Eg1),
    TProcedureInfo.Create('OccurrencesOf_Eg2', @OccurrencesOf_Eg2)
  )
);

end.
