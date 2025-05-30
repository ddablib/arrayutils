{
 * Example code for TArrayUtils.IndicesOf<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit IndicesOf;

interface

implementation

uses
  SysUtils,
  Generics.Defaults,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure IndicesOf_Eg1;
var
  A: TArray<Byte>;
  Got, Expected: TArray<Integer>;
  EqComparerFn: TEqualityComparison<Byte>;
begin
  EqComparerFn := function (const L, R: Byte): Boolean
    begin
      Result := L = R;
    end;

  A := TArray<Byte>.Create(0, 3, 2, 1, 2, 3, 1, 3, 3);

  Got := TArrayUtils.IndicesOf<Byte>(3, A, EqComparerFn);
  Expected := TArray<Integer>.Create(1, 5, 7, 8);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));

  Got := TArrayUtils.IndicesOf<Byte>(4, A, EqComparerFn);
  Expected := TArray<Integer>.Create();
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

procedure IndicesOf_Eg2;
var
  A: TArray<string>;
  Got, Expected: TArray<Integer>;
  EqComparer: IEqualityComparer<string>;
begin
  EqComparer := TDelegatedEqualityComparer<string>.Create(
    SameText,
    function (const AValue: string): Integer
    begin
      // Don't do this unless you KNOW the hasher function won't be called
      Result := 0;
    end
  );
  A := TArray<string>.Create('foo', 'FOO', 'bar', 'baz', 'Foo');
  Got := TArrayUtils.IndicesOf<string>('foo', A, EqComparer);
  Expected := TArray<Integer>.Create(0, 1, 4);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

initialization

TRegistrar.Add(
  'IndicesOf<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('IndicesOf_Eg1', @IndicesOf_Eg1),
    TProcedureInfo.Create('IndicesOf_Eg2', @IndicesOf_Eg2)
  )
);

end.
