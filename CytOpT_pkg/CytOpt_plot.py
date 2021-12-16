import matplotlib.pyplot as plt
import numpy as np
import pylab as p
import seaborn as sns


def plot_py_1(X_source, X_target, Lab_source, h_source, names_pop):
    plt.figure(figsize=(20, 15))
    plt.subplot(2, 2, 1)
    for it in [0, 1]:
        plt.scatter(X_source[Lab_source == it, 0],
                    X_source[Lab_source == it, 1],
                    label=names_pop[it])
    plt.xlabel('CD4', size=25)
    plt.ylabel('CD8', size=25)
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    plt.legend(loc='lower left', fontsize=25, markerscale=3)
    plt.title('Stanford 1A - Source data', size=30)
    #
    plt.subplot(2, 2, 2)
    plt.scatter(X_target[:, 0], X_target[:, 1], c='grey')
    plt.xlabel('CD4', size=25)
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    plt.title('Stanford 3A - Target data', size=30)
    #
    plt.subplot(2, 2, 3)
    sns.barplot(x=names_pop, y=np.array(h_source))
    plt.ylabel('Percentage', size=25)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    p.show()


def plot_py_2(X_tar_display, Lab_target_hat_one, Lab_target, names_pop):
    plt.figure(figsize=(15, 6))
    plt.subplot(1, 2, 1)
    for it in [1, 2]:
        plt.scatter(X_tar_display[Lab_target_hat_one == it, 0],
                    X_tar_display[Lab_target_hat_one == it, 1],
                    label=names_pop[it - 1])
    plt.xlabel('CD4', size=20)
    plt.ylabel('CD8', size=20)
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xticks(fontsize=16)
    plt.yticks(fontsize=16)
    plt.legend(loc='lower left', fontsize=20, markerscale=2)
    plt.title('Stanford3A - Target data - Transport Clustering', size=20)

    plt.subplot(1, 2, 2)
    for it in [0, 1]:
        plt.scatter(X_tar_display[Lab_target == it, 0],
                    X_tar_display[Lab_target == it, 1],
                    label=names_pop[it - 1])
    plt.xlabel('CD4', size=20)
    plt.ylabel('CD8', size=20)
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xticks(fontsize=16)
    plt.yticks(fontsize=16)
    plt.legend(loc='lower left', fontsize=20, markerscale=2)
    plt.title('Stanford3A - Target data - True clustering', size=20)
    p.show()


def plot_py_prop1(Res_df):
    plt.figure(figsize=(10, 7))
    sns.barplot(x='Method', y='Percentage', hue='Cell_Type', data=Res_df)
    plt.legend(fontsize=22)
    plt.ylabel('Proportions', size=22)
    plt.xlabel('')
    plt.xticks(fontsize=22)
    plt.yticks(fontsize=22)
    p.show()


def plot_py_prop2(df_res1):
    plt.figure(figsize=(8, 5))
    sns.barplot(x='Classes', y='Proportions', hue='Methode', data=df_res1,
                palette=['darkgreen', 'lime', 'lightcoral'])
    plt.title('CytOpt estimation and Manual estimation', size=16)
    plt.legend(loc='upper left', fontsize=14)
    plt.xlabel('Classes', size=14)
    plt.ylabel('Proportions', size=14)
    plt.ylim(0, 0.8)
    plt.xticks(fontsize=14)
    plt.yticks(fontsize=14)
    p.show()


def plot_py_3(X_tar_display,Lab_target_hat_one,names_pop,Lab_target_hat_two,Lab_target):
    # Display of the label transfer results without or with reweighting.
    plt.figure(figsize=(23, 7))
    plt.subplot(1, 3, 1)
    for it in [1, 2]:
        plt.scatter(X_tar_display[Lab_target_hat_one == it, 0],
                    X_tar_display[Lab_target_hat_one == it, 1],
                    label=names_pop[it - 1])
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.ylabel('CD8', size=25)
    plt.xlabel('CD4', size=25)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    plt.legend(loc='lower left', fontsize=25, markerscale=3)
    plt.subplot(1, 3, 2)
    for it in [1, 2]:
        plt.scatter(X_tar_display[Lab_target_hat_two == it, 0],
                    X_tar_display[Lab_target_hat_two == it, 1],
                    label=names_pop[it - 1])
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xlabel('CD4', size=25)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    plt.legend(loc='lower left', fontsize=25, markerscale=3)
    plt.subplot(1, 3, 3)
    for it in [0, 1]:
        plt.scatter(X_tar_display[Lab_target == it, 0],
                    X_tar_display[Lab_target == it, 1],
                    label=names_pop[it - 1])
    plt.xlim(-1500, 3500)
    plt.ylim(-1500, 4000)
    plt.xlabel('CD4', size=25)
    plt.xticks(fontsize=25)
    plt.yticks(fontsize=25)
    plt.legend(loc='lower left', fontsize=25, markerscale=3)
    p.show()


def plot_py_4(X_sou_display, Lab_source, names_pop, X_target_lag, n_sub, indices, indices_two):
    n_sub = int(n_sub)
    plt.figure(figsize=(16, 6))
    plt.subplot(1, 2, 1)
    for it in [0, 1]:
        plt.scatter(X_sou_display[:, 0][Lab_source == it],
                    X_sou_display[:, 1][Lab_source == it],
                    label=names_pop[it])

    plt.scatter(X_target_lag[:, 0], X_target_lag[:, 1], c='grey')
    for i in range(n_sub):
        plt.plot([X_sou_display[int(indices[i, 0]), 0], X_target_lag[int(indices[i, 1]), 0]],
                 [X_sou_display[int(indices[i, 0]), 1], X_target_lag[int(indices[i, 1]), 1]],
                 c='green', alpha=0.2)
    plt.title('Without reweighting', size=25)
    plt.xlabel('CD4', size=20)
    plt.ylabel('CD8', size=20)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)
    plt.legend(loc='lower left', fontsize=20, markerscale=3)

    plt.subplot(1, 2, 2)
    for it in [0, 1]:
        plt.scatter(X_sou_display[:, 0][Lab_source == it],
                    X_sou_display[:, 1][Lab_source == it],
                    label=names_pop[it])

    plt.scatter(X_target_lag[:, 0], X_target_lag[:, 1], c='grey')
    for i in range(n_sub):
        plt.plot([X_sou_display[int(indices_two[i, 0]), 0], X_target_lag[int(indices_two[i, 1]), 0]],
                 [X_sou_display[int(indices_two[i, 0]), 1], X_target_lag[int(indices_two[i, 1]), 1]],
                 c='green', alpha=0.5)
    plt.title('With reweighting', size=25)
    plt.xlabel('CD4', size=20)
    # plt.ylabel('CD8', size=20)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)
    plt.legend(loc='lower left', fontsize=20, markerscale=3)
    p.show()


def plot_py_Comp(n_0, n_stop, Minmax_monitoring, Desasc_monitoring):
    n_0 = int(n_0)
    n_stop = int(n_stop)
    plt.figure(figsize=(12,7))
    plt.plot(np.arange(n_0,n_stop), Minmax_monitoring[n_0:n_stop], c='maroon',
             label='MinMax-Swapping procedure')
    plt.plot(np.arange(n_0,n_stop), Desasc_monitoring[n_0:n_stop], c='navy',
            label='Descent-Ascent procedure')
    plt.legend(loc='best', fontsize=16)
    plt.xlabel('Iteration', size=20)
    plt.ylabel(r'KL$(\hat{p}|p)$', size=20)
    plt.xticks(size=18)
    plt.yticks(size=18)
    p.show()


# plot two Bland Altman
def Bland_Altman_Comp(Dico_resDesac, Dico_resMinmax, sd_diff, n_pal):
    try:
        n_pal = n_pal
    except TypeError as e:
        raise TypeError("exponent must be an integer") from e

    palettes = ['tab:blue', 'tab:orange', 'tab:green',
                'tab:red', 'tab:purple', 'tab:brown', 'tab:pink',
                'tab:gray', 'tab:olive', 'tab:cyan']
    titles = ['CytOpT Desasc', 'CytOpT Minmax']
    Dico_res = {"Dico_resDesac": Dico_resDesac, "Dico_resMinmax": Dico_resMinmax}
    print(Dico_res)
    plt.figure(figsize=(20, 10))
    for idx, item in enumerate(Dico_res):
        plt.subplot(1, 2, idx + 1)
        sns.scatterplot(x='Mean', y='Diff', hue='Classe',
                        palette=palettes[0:n_pal],
                        s=200, data=list(Dico_res.values())[idx])
        plt.xlabel(r'$(p_i + \hat{p}_i)/2$', size=22)
        plt.ylabel(r'$(p_i - \hat{p}_i)$', size=22)
        plt.xlim(-0.02, 0.65)
        plt.ylim(-0.25, 0.25)
        plt.xticks(size=15)
        plt.yticks(size=15)
        plt.hlines(1.96 * sd_diff[idx], xmin=0, xmax=0.4, linestyles='dashed', label='+1.96 SD')
        plt.hlines(-1.96 * sd_diff[idx], xmin=0, xmax=0.4, linestyles='dashed', label='-1.96 SD')
        plt.hlines(0, xmin=0, xmax=0.4, label='Mean')
        plt.legend(fontsize=17, markerscale=2)
        plt.title(titles[idx], size=25)
    p.show()


# Bland Altman one model
def Bland_Altman(df_res_Cytopt, sd_diff, n_pal, title):
    try:
        n_pal = n_pal
    except TypeError as e:
        raise TypeError("exponent must be an integer") from e

    palettes = ['tab:blue', 'tab:orange', 'tab:green',
                'tab:red', 'tab:purple', 'tab:brown', 'tab:pink',
                'tab:gray', 'tab:olive', 'tab:cyan']
    plt.figure(figsize=(15, 10))
    sns.scatterplot(x='Mean', y='Diff', hue='Classe',
                    palette=palettes[0:n_pal],
                    s=200, data=df_res_Cytopt)
    plt.xlabel(r'$(p_i + \hat{p}_i)/2$', size=22)
    plt.ylabel(r'$(p_i - \hat{p}_i)$', size=22)
    plt.xlim(-0.02, 0.5)
    plt.ylim(-0.15, 0.15)
    plt.xticks(size=20)
    plt.yticks(size=20)
    plt.hlines(1.96 * sd_diff, xmin=0, xmax=0.4, linestyles='dashed', label='+1.96 SD')
    plt.hlines(-1.96 * sd_diff, xmin=0, xmax=0.4, linestyles='dashed', label='-1.96 SD')
    plt.hlines(0, xmin=0, xmax=0.4, label='Mean')
    plt.legend(fontsize=17, markerscale=2)
    plt.title(title, size=25)
    p.show()