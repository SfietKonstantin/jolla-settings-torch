/*
 * Copyright (C) 2014 Lucien XU <sfietkonstantin@free.fr>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * The names of its contributors may not be used to endorse or promote
 *     products derived from this software without specific prior written
 *     permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

#include "torchdobject.h"
#include <QtCore/QCoreApplication>

TorchDObject::TorchDObject(QObject *parent) :
    QObject(parent), m_enabled(false), m_src(0), m_sink(0), m_pipeline(0)
{
    // Init
    gst_init(NULL, NULL);
}

TorchDObject::~TorchDObject()
{
    stopTorch();
}

bool TorchDObject::isEnabled() const
{
    return m_enabled;
}

void TorchDObject::setEnabled(bool enabled)
{
    if (m_enabled != enabled) {
        if (enabled) {
            startTorch();
        } else {
            stopTorch();
        }
        emit enabledChanged(m_enabled);
    }
}

void TorchDObject::enable()
{
    setEnabled(true);
}

void TorchDObject::disable()
{
    setEnabled(false);
}

void TorchDObject::startTorch()
{
    if (m_src || m_sink || m_pipeline) {
        return;
    }

    m_src = gst_element_factory_make("droidcamsrc", "src");
    m_sink = gst_element_factory_make("droideglsink", "sink");
    m_pipeline = gst_pipeline_new ("torchd-pipeline");
    if (!m_src || !m_sink || !m_pipeline) {
        QCoreApplication::exit(-1);
        return;
    }
    // Build the pipeline
    gst_bin_add_many(GST_BIN (m_pipeline), m_src, m_sink, NULL);
    if (gst_element_link(m_src, m_sink) != TRUE) {
        gst_object_unref(m_pipeline);
        gst_object_unref(m_src);
        gst_object_unref(m_sink);
        QCoreApplication::exit(-1);
        return;
    }
    g_object_set(G_OBJECT(m_src), "video-torch", 1, NULL);
    g_object_set(G_OBJECT(m_src), "mode", 2, NULL);
    gst_element_set_state(m_pipeline, GST_STATE_PLAYING);
    m_enabled = true;
}

void TorchDObject::stopTorch()
{
    if (!m_src || !m_sink || !m_pipeline) {
        return;
    }

    gst_element_set_state(m_pipeline, GST_STATE_NULL);
    gst_object_unref(m_pipeline);
    m_src = 0;
    m_sink = 0;
    m_pipeline = 0;
    m_enabled = false;
}
