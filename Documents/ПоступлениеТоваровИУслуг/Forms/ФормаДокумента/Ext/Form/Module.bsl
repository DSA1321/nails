﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда
		СтрокаТЧ.СтатьяЗатрат = РаботаСНоменклатурой.ПолучитьСтатьюЗатрат(СтрокаТЧ.Услуга);
	Иначе
		СтрокаТЧ.Услуга = "";
	КонецЕсли;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма") + Объект.Товары.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма") + Объект.Товары.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСТрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма") + Объект.Товары.Итог("Сумма");
КонецПроцедуры

