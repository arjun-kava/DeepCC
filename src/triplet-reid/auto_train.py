import os

train_set = 'data/duke_train.csv'
image_root = 'D:/Workspace/Research/Dataset/DukeMTMC/DukeMTMC-reID'
experiment_root = 'experiments/demo_weighted_triplet'

command = 'python' + ' train.py' + \
    ' --train_set %s' % train_set + \
    ' --model_name %s' % 'resnet_v1_50' + \
    ' --initial_checkpoint %s' % 'resnet_v1_50.ckpt' + \
    ' --image_root %s' % image_root + \
    ' --experiment_root %s' % experiment_root + \
    ' --embedding_dim %d' % 128 + \
    ' --batch_p %d' % 18 + \
    ' --batch_k %d' % 4 + \
    ' --pre_crop_height %d --pre_crop_width %d' % (288, 144) + \
    ' --net_input_height %d --net_input_width %d' % (256, 128) + \
    ' --margin %s' % 'soft' + \
    ' --metric %s' % 'euclidean' + \
    ' --loss %s' % 'weighted_triplet' + \
    ' --learning_rate %f' % 0.0003 + \
    ' --train_iterations %d' % 25000 + \
    ' --hard_pool_size %d' % 0 + \
    ' --decay_start_iteration %d' % 15000 + \
    ' --checkpoint_frequency %d' % 1000 + \
    ' --augment' + \
    ' --resume'

os.system(command)