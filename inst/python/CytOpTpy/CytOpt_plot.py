import matplotlib.pyplot as plt
import numpy as np
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
    plt.show()


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
    plt.show()


def plot_py_prop1(Res_df):
    plt.figure(figsize=(10, 7))
    sns.barplot(x='Method', y='Percentage', hue='Cell_Type', data=Res_df)
    plt.legend(fontsize=22)
    plt.ylabel('Proportions', size=22)
    plt.xlabel('')
    plt.xticks(fontsize=22)
    plt.yticks(fontsize=22)
    plt.show()


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
    plt.show()


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
    plt.show()


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
    plt.show()


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
    plt.show()
