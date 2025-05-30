{
 * Example code for TArrayUtils.EqualStart<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit EqualStart;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure EqualStart_Eg1;
var
  A, B: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3);
  B := TArray<Integer>.Create(1, 2, 5, 6);
  EqComparerFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;
  Assert(TArrayUtils.EqualStart<Integer>(A, B, 1, EqComparerFn) = True);
  Assert(TArrayUtils.EqualStart<Integer>(A, B, 2, EqComparerFn) = True);
  Assert(TArrayUtils.EqualStart<Integer>(A, B, 3, EqComparerFn) = False);
end;

procedure EqualStart_Eg2;
var
  A, B: TArray<string>;
  EqComparerObj: IEqualityComparer<string>;
begin
  A := TArray<string>.Create('a', 'b', 'c');
  B := TArray<string>.Create('a', 'b');
  EqComparerObj := TDelegatedEqualityComparer<string>.Create(
    SameStr,
    function (const Value: string): Integer
    begin
      // This is only safe because the hash function isn't called by EqualStart
      Result := 0;
    end
  );
  Assert(TArrayUtils.EqualStart<string>(A, B, 2, EqComparerObj) = True);
  Assert(TArrayUtils.EqualStart<string>(A, B, 3, EqComparerObj) = False);
end;

initialization

TRegistrar.Add(
  'EqualStart<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('EqualStart_Eg1', @EqualStart_Eg1),
    TProcedureInfo.Create('EqualStart_Eg2', @EqualStart_Eg2)
  )
);

end.
