# Налаштування Cadence Xcelium
TOOL = xrun

# Прапорці для запуску:
# -f filelist.f: список файлів
# -gui: запуск графічного інтерфейсу
# -access +rwc: доступ до читання/запису/керування для дебагу
# -coverage all: збір усіх типів покриття (code, functional)
# -covoverwrite: дозволяє перезаписувати існуючу базу покриття
# -sv: підтримка SystemVerilog
FLAGS = -f filelist.f -gui -access +rwc -coverage all -covoverwrite -sv

# Команда за замовчуванням
all: run

# Запуск симуляції
run:
	$(TOOL) $(FLAGS) top.sv

# Очищення проекту від усіх тимчасових файлів симулятора та логів
clean:
	rm -rf xcelium.d xmsim.log xrun.history xrun.log
	rm -rf waves.shm cov_work .simvision
	rm -rf INCA_libs
	rm -f dump.vcd *.err *.key
	@echo "Project cleaned and coverage data removed."
