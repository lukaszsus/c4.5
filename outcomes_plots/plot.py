#!/usr/bin/python3.6

import os
import seaborn as sns
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

SRC_DIR = '../outcomes_summary/'
column_names = ['kfold', 'type', 'metric', '2','3','4','5','6','7','8','9']
folds = range(2,10)
metric_names = ['Accuracy', 'Precision', 'Recall', 'F1']
file_names = ["diabetes", "glass", "wine"]
var_file_names = ["var_diabetes", "var_glass", "var_wine"]
params_values = {"C001": 0.01,
          "C01": 0.1,
          "C025": 0.25,
          "C05": 0.5,
          "M1": 1,
          "M2": 2,
          "M4": 4,
          "M10": 10,
          "N2": 2,
          "N3": 3,
          "N6": 6,
          "N9": 9,
            "Default": 0}
params = {"C001": "C",
          "C01": "C",
          "C025": "C",
          "C05": "C",
          "M1": "M",
          "M2": "M",
          "M4": "M",
          "M10": "M",
          "N2": "N",
          "N3": "N",
          "N6": "N",
          "N9": "N",
          "Default": "D"}

def plot_kfolds_means(file_name):
    file_path = file_name + ".csv"
    file_path = os.path.join(SRC_DIR, file_path)
    data = pd.read_csv(file_path, names=column_names)
    for metric_name in metric_names:
        metric_data = data[data["metric"] == metric_name]
        strat = metric_data[metric_data["kfold"] == "stratified"]
        strat_means = strat.mean(0)
        unstrat = metric_data[metric_data["kfold"] == "unstrat"]
        unstrat_means = unstrat.mean(0)
        out_col_names = ["kfold"]
        out_data = pd.DataFrame([i for i in range(2,10)], columns=out_col_names)
        out_data["strat"] = np.asarray(strat_means)
        out_data["unstrat"] = np.asarray(unstrat_means)

        save_path = file_name + "-" + metric_name + ".csv"
        out_data.to_csv(save_path)

        data_to_plot_strat = pd.DataFrame([i for i in range(2,10)], columns=out_col_names)
        data_to_plot_unstrat = pd.DataFrame([i for i in range(2, 10)], columns=out_col_names)
        data_to_plot_strat["type"] =  np.asarray(["stratified" for i in range(2, 10)])
        data_to_plot_unstrat["type"] = np.asarray(["unstratified" for i in range(2, 10)])
        data_to_plot_strat[metric_name] = out_data["strat"]
        data_to_plot_unstrat[metric_name] = out_data["unstrat"]
        data_to_plot = pd.concat([data_to_plot_strat, data_to_plot_unstrat])

        # plot
        fig, ax = plt.subplots()
        ax = sns.scatterplot(hue="type", x="kfold", y=metric_name, data=data_to_plot)
        ax.set_title(metric_name + " od liczby foldow")
        path_pdf = metric_name + "-" + file_name + ".pdf"
        path_png = metric_name + "-" + file_name + ".png"
        fig.savefig(path_pdf, bbox_inches='tight')
        fig.savefig(path_png, bbox_inches='tight')


def plot_kfolds_means_every_file():
    for file in file_names:
        plot_kfolds_means(file)


def plot_kfolds_vars_every_file():
    for file in var_file_names:
        plot_kfolds_means(file)



def plot_mean_depths():
    data = _get_basic_data_from_outcomes()
    playouts = _get_mean_stat_per_game_from_all_dirs("mean", "leaves.csv")
    data["srednia glebokosc liscia"] = playouts.transpose()
    dst_data_path = os.path.join(DST_DIR, "srednia_glebokosc_liscia.csv")
    data.to_csv(dst_data_path, index=False)

    fig, ax = plt.subplots()
    ax = sns.scatterplot(x="czas [warunek petli]", y="srednia glebokosc liscia", hue="przeciwnik", data=data)
    ax.set_title('Srednia glebokosc liscia od czasu')
    path_pdf = os.path.join(DST_DIR, "srednia_glebokosc_liscia.pdf")
    path_png = os.path.join(DST_DIR, "srednia_glebokosc_liscia.png")
    fig.savefig(path_pdf, bbox_inches='tight')
    fig.savefig(path_png, bbox_inches='tight')


def plot_metrics(file_name):
    file_path = file_name + ".csv"
    file_path = os.path.join(SRC_DIR, file_path)
    data = pd.read_csv(file_path, names=column_names)
    mean_data = data.mean(1)
    data["mean"] = np.asarray(mean_data)
    X = [params_values[str(x)] for x in data['type']]
    data["X"] = np.asarray(X)
    p = [params[str(x)] for x in data['type']]
    data["param"] = np.asarray(p)
    data = data[data["kfold"] == "stratified"]
    data = data[['metric', 'X', 'param', 'mean']]
    save_path = file_name +"-metrics.csv"
    data.to_csv(save_path)

    for param_name in data["param"].unique():
        param_data = data[data["param"] == param_name]

        # plot
        fig, ax = plt.subplots()
        ax = sns.scatterplot(hue="metric", x="X", y="mean", data=param_data)
        ax.set_title("Jakosc klasyfikacja w zaleznosci " + param_name)
        path_pdf = param_name + "-" + file_name + ".pdf"
        path_png = param_name + "-" + file_name + ".png"
        fig.savefig(path_pdf, bbox_inches='tight')
        fig.savefig(path_png, bbox_inches='tight')


def plot_all_files_metrics():
    for file_name in file_names:
        plot_metrics(file_name)

if __name__ == '__main__':
    #plot_kfolds_means_every_file()
    #plot_kfolds_vars_every_file()
    plot_all_files_metrics()
