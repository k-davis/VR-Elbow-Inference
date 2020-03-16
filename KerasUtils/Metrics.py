import keras.backend as kb


def mse_between_points(y_true, y_pred):
    loss = kb.mean(
        kb.sum(kb.square(kb.sqrt(kb.sum(kb.square(y_true - y_pred), axis=1))))
    )

    return loss


def mean_diff_error(y_true, y_pred):
    loss = kb.mean(kb.sum(kb.sqrt(kb.sum(kb.square(y_true - y_pred), axis=1))))

    return loss
