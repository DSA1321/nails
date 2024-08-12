﻿Процедура ОбработкаПроведения(Отказ, Режим)
	СтруктураУчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата);
	Если СтруктураУчетнаяПолитика.СпособУчетаЗапаса = Перечисления.СпособыСписанияЗапасов.FEFO Тогда
		ОтражатьСрокиГодности = Истина;
	Иначе
		ОтражатьСрокиГодности = Ложь;
	КонецЕсли;
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.УчетЗатрат.Записывать = Истина;
	Движения.Хозрасчетный.Записывать = Истина;
	СчетКредита = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПоступлениеТоваровИУслугТовары.Номенклатура КАК Номенклатура,
	|	ПоступлениеТоваровИУслугТовары.СрокГодности КАК СрокГодности,
	|	СУММА(ПоступлениеТоваровИУслугТовары.Количество) КАК Количество,
	|	СУММА(ПоступлениеТоваровИУслугТовары.Сумма) КАК Сумма,
	|	NULL КАК СтатьяЗатрат,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
	|ПОМЕСТИТЬ ВТ_Ном
	|ИЗ
	|	Документ.ПоступлениеТоваровИУслуг.Товары КАК ПоступлениеТоваровИУслугТовары
	|ГДЕ
	|	ПоступлениеТоваровИУслугТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровИУслугТовары.Номенклатура,
	|	ПоступлениеТоваровИУслугТовары.СрокГодности,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.СчетБухгалтерскогоУчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	NULL,
	|	NULL,
	|	СУММА(ПоступлениеТоваровИУслугУслуги.Сумма),
	|	ПоступлениеТоваровИУслугУслуги.СтатьяЗатрат,
	|	ПоступлениеТоваровИУслугУслуги.Услуга.СчетБухгалтерскогоУчета
	|ИЗ
	|	Документ.ПоступлениеТоваровИУслуг.Услуги КАК ПоступлениеТоваровИУслугУслуги
	|ГДЕ
	|	ПоступлениеТоваровИУслугУслуги.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровИУслугУслуги.СтатьяЗатрат,
	|	ПоступлениеТоваровИУслугУслуги.Услуга.СчетБухгалтерскогоУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Ном.Номенклатура КАК Номенклатура,
	|	ВТ_Ном.СтатьяЗатрат КАК СтатьяЗатрат,
	|	ВТ_Ном.Количество КАК Количество,
	|	ВТ_Ном.Сумма КАК Сумма,
	|	ВТ_Ном.СрокГодности КАК СрокГодности,
	|	ВЫБОР
	|		КОГДА ВТ_Ном.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|				ИЛИ ВТ_Ном.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Материал)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТовар,
	|	ВТ_Ном.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
	|ИЗ
	|	ВТ_Ном КАК ВТ_Ном
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоТовар";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если  Выборка.ЭтоТовар Тогда
			Движение = Движения.ТоварыНаСкладах.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Номенклатура = Выборка.Номенклатура;
			Движение.Сумма = Выборка.Сумма;
			Движение.Склад = Склад;
			Движение.Количество = Выборка.Количество;
			Если ОтражатьСрокиГодности Тогда
				Движение.СрокГодности = Выборка.СрокГодности;
			КонецЕсли;
			Движение = Движения.Хозрасчетный.Добавить();
			Движение.СчетДт = Выборка.СчетБухгалтерскогоУчета;
			Движение.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
			Движение.Период = Дата;
			Движение.Сумма = Выборка.Сумма;
			Движение.Содержание = "Отражено поступление товарно-материальных ценностей от поставщика";
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура] = Выборка.Номенклатура;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты] = Контрагент;
		Иначе
			ДвижениеЗатрат = Движения.УчетЗатрат.Добавить();
			ЗаполнитьЗначенияСвойств(ДвижениеЗатрат, Выборка);
			ДвижениеЗатрат.Период = Дата;
			Движение = Движения.Хозрасчетный.Добавить();
			Движение.СчетДт = Выборка.СчетБухгалтерскогоУчета;
			Движение.СчетКт = СчетКредита;
			Движение.Период = Дата;
			Движение.Сумма = Выборка.Сумма;
			Движение.Содержание = "Отражено поступление услуг от поставщика";
			БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, Выборка.СтатьяЗатрат);
			БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, Контрагент);
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
КонецПроцедуры