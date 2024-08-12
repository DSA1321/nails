﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ЗаказыКлиентов.Записывать = Истина;
	Движение = Движения.ЗаказыКлиентов.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Клиент = Клиент;
	Движение.ЗаказКлиента = Ссылка;
	движение.Сумма = Услуги.Итог("Сумма");
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	СуммаДокумента = Услуги.Итог("Сумма");
	Если НЕ ЗначениеЗаполнено(ДатаОкончанияЗаписи) Тогда
		ДлительностьУслуг = РассчитатьДатуОкончанияЗаписи();
		Если ДлительностьУслуг = 0 Тогда
			ДлительностьУслуг = 60;
		КонецЕсли;
		ДатаОкончанияЗаписи = ДатаЗаписи + ДлительностьУслуг*60;
	КонецЕсли;
КонецПроцедуры

Функция РассчитатьДатуОкончанияЗаписи()
	ТЧУслуги = Услуги.Выгрузить(, "Услуга");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЧУслуги", ТЧУслуги);
	Запрос.Текст = "ВЫБРАТЬ
	|    ТЧУслуги.Услуга КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|    &ТЧУслуги КАК ТЧУслуги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|    СУММА(Ном.ДлительностьУслуги) КАК ДлительностьУслуги
	|ИЗ
	|    ВТ_Номенклатура КАК ВТ_Номенклатура
	|        ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	|        ПО ВТ_Номенклатура.Номенклатура = Ном.Ссылка";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ДлительностьУслуги;
КонецФункции
