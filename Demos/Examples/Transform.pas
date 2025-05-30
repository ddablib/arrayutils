{
 * Example code for TArrayUtils.Transform<TIn,TOut>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Transform;

interface

implementation

uses
  SysUtils,
  Math,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

type
  TOneToTen = 1..10;

procedure Transform_Eg1;
var
  A: TArray<TOneToTen>;
  Got, Expected: TArray<string>;
  RomanTransformer: TArrayUtils.TTransformer<TOneToTen,string>;
begin
  {$RangeChecks On}
  RomanTransformer := function (const N: TOneToTen): string
    const
      Numerals: array[TOneToTen] of string = (
        'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'
      );
    begin
      Result := Numerals[N];
    end;

  A := TArray<TOneToTen>.Create(3, 5, 8, 2, 9);
  Got := TArrayUtils.Transform<TOneToTen, string>(A, RomanTransformer);
  Expected := TArray<string>.Create('III', 'V', 'VIII', 'II', 'IX');
  Assert(TArrayUtils.Equal<string>(Expected, Got, SameStr));
end;

procedure Transform_Eq2;
var
  A, Got, Expected: TArray<Cardinal>;
begin
  A := TArray<Cardinal>.Create(5, 8, 3, 2, 0, 1, 3);
  Got := TArrayUtils.Transform<Cardinal,Cardinal>(
    A,
    function (const AValue: Cardinal; const AIndex: Integer;
      const A: array of Cardinal): Cardinal
    begin
      Result := Round(IntPower(AValue, AIndex + 1));
    end
  );
  Expected := TArray<Cardinal>.Create(5, 64, 27, 16, 0, 1, 2187);
  Assert(TArrayUtils.Equal<Cardinal>(Expected, Got));
end;

initialization

TRegistrar.Add(
  'Transform<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Transform_Eg1', @Transform_Eg1),
    TProcedureInfo.Create('Transform_Eq2', @Transform_Eq2)
  )
);

end.
